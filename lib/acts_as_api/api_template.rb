module ActsAsApi
  # Represents an api template for a model.
  # This class should not be initiated by yourself, api templates
  # are created by defining them in the model by calling: +api_accessible+.
  #
  # The api template is configured in the block passed to +api_accessible+.
  #
  # Please note that +ApiTemplate+ inherits from +Hash+ so you can use all
  # kind of +Hash+ and +Enumerable+ methods to manipulate the template.
  class ApiTemplate < Hash

    # The name of the api template as a Symbol.
    attr_accessor :api_template
    
    # Returns a new ApiTemplate with the api template name
    # set to the passed template.
    def self.create(template)
      t = ApiTemplate.new
      t.api_template = template
      return t
    end

    # Adds a field to the api template
    #
    # The value passed can be one of the following:
    #  * Symbol - the method with the same name will be called on the model when rendering.
    #  * String - must be in the form "method1.method2.method3", will call this method chain.
    #  * Hash - will be added as a sub hash and all its items will be resolved the way described above.
    #
    # Possible options to pass:
    #  * :template - Determine the template that should be used to render the item if it is
    #    +api_accessible+ itself.
    def add(val, options = {})
      item_key = (options[:as] || val).to_sym

      self[item_key] = val

      @options ||= {}
      @options[item_key] = options
    end

    # Removes a field from the template
    def remove(field)
      self.delete(field)
    end

    # Returns the options of a field in the api template
    def options_for(field)
      @options[field]
    end

    # Returns the passed option of a field in the api template
    def option_for(field, option)
      @options[field][option] if @options[field]
    end

    # If a special template name for the passed item is specified
    # it will be returned, if not the original api template.
    def api_template_for(fieldset, field)
      return api_template unless fieldset.is_a? ActsAsApi::ApiTemplate
      fieldset.option_for(field, :template) || api_template
    end

    # Decides if the passed item should be added to
    # the response based on the conditional options passed.
    def allowed_to_render?(fieldset, field, model)
      return true unless fieldset.is_a? ActsAsApi::ApiTemplate
      allowed = true
      allowed = condition_fulfilled?(model, fieldset.option_for(field, :if)) if fieldset.option_for(field, :if)
      allowed = !(condition_fulfilled?(model, fieldset.option_for(field, :unless))) if fieldset.option_for(field, :unless)
      return allowed
    end

    # Checks if a condition is fulfilled
    # (result is not nil or false)
    def condition_fulfilled?(model, condition)
      case condition
      when Symbol
        result = model.send(condition)
      when Proc
        result = condition.call(model)
      end
      !result.nil? && !result.is_a?(FalseClass)
    end

    # Generates a hash that represents the api response based on this
    # template for the passed model instance.
    def to_response_hash(model)
      queue = []
      api_output = {}
      
      queue << { :output =>  api_output, :item => self }

      until queue.empty? do
        leaf = queue.pop
        fieldset = leaf[:item]
                
        fieldset.each do |field, value|

          next unless allowed_to_render?(fieldset, field, model)

          case value
          when Symbol
            if model.respond_to?(value)
              out = model.send value
            end

          when Proc
            out = value.call(model)

          when String
            # go up the call chain
            out = model
            value.split(".").each do |method|
              out = out.send(method.to_sym)
            end

          when Hash
            leaf[:output][field] ||= {}
            queue << { :output =>  leaf[:output][field], :item => value }
            next
          end

          if out.respond_to?(:as_api_response)
            sub_template = api_template_for(fieldset, field)
            out = out.send(:as_api_response, sub_template)
          end

          leaf[:output][field] = out
        end
        
      end
      
      api_output
    end
    
  end
end
