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

    # Adds an item to the api template
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

    # Removes an item from the template
    def remove(item)
      self.delete(item)
    end

    # Returns the options of an item in the api template
    def options_for(item)
      @options[item]
    end

    # Returns the passed option of an item in the api template
    def option_for(item, option)
      @options[item][option] if @options[item]
    end
    
    # If a special template name for the passed item is specified
    # it will be returned, if not the original api template.
    def api_template_for(parent, item)
      return api_template unless parent.is_a? ActsAsApi::ApiTemplate
      parent.option_for(item, :template) || api_template
    end
    
    # Decides if the passed item should be added to
    # the response.
    def allowed_to_render?(parent, item)
      # TODO implement :if, :unless options
      true
    end

    # Generates a hash that represents the api response based on this
    # template for the passed model instance.
    def to_response_hash(model)
      queue = []
      api_output = {}
      queue << { :parent =>  api_output, :item => self }

      until queue.empty? do
          leaf = queue.pop

          leaf[:item].each do |k,v|

            next unless allowed_to_render?(leaf[:item], k)

            case v
            when Symbol
              if model.respond_to?(v)
                out = model.send v
              end

            when Proc
              out = v.call(model)

            when String
              # go up the call chain
              out = model
              v.split(".").each do |method|
                out = out.send(method.to_sym)
              end

            when Hash
              leaf[:parent][k] ||= {}
              queue << { :parent =>  leaf[:parent][k], :item => v}
              next
            end

            if out.respond_to?(:as_api_response)
              sub_template = api_template_for(leaf[:item], k)
              out = out.send(:as_api_response, sub_template)
            end

            leaf[:parent][k] = out
          end
        end

        api_output
      end

    end
  end
