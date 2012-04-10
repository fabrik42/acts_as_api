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

    attr_reader :options

    def initialize(api_template)
      self.api_template = api_template
      @options ||= {}
    end

    def merge!(other_hash, &block)
      super
      self.options.merge!(other_hash.options) if other_hash.respond_to?(:options)
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
      fieldset.option_for(field, :template) || api_template
    end

    # Decides if the passed item should be added to
    # the response based on the conditional options passed.
    def allowed_to_render?(fieldset, field, model, options)
      return true unless fieldset.is_a? ActsAsApi::ApiTemplate
      
      fieldset_options = fieldset.options_for(field)
      
      if fieldset_options[:unless]
        !(condition_fulfilled?(model, fieldset_options[:unless], options))
      elsif fieldset_options[:if]
        condition_fulfilled?(model, fieldset_options[:if], options)
      else
        true
      end
    end

    # Checks if a condition is fulfilled
    # (result is not nil or false)
    def condition_fulfilled?(model, condition, options)
      case condition
      when Symbol
        result = model.send(condition)
      when Proc
        result = call_proc(condition, model, options)
      end
      !!result
    end

    # Generates a hash that represents the api response based on this
    # template for the passed model instance.
    def to_response_hash(model, fieldset = self, options = {})
      api_output = {}

      fieldset.each do |field, value|
        next unless allowed_to_render?(fieldset, field, model, options)

        out = process_value(model, value, options)

        if out.respond_to?(:as_api_response)
          sub_template = api_template_for(fieldset, field)
          out = out.as_api_response(sub_template, options)
        end

        api_output[field] = out
      end

      api_output
    end

  private

    def process_value(model, value, options)
      case value
      when Symbol
        model.send(value)
      when Proc
        call_proc(value,model,options)
      when String
        value.split('.').inject(model) { |result, method| result.send(method) }
      when Hash
        to_response_hash(model, value)
      end
    end

    def call_proc(the_proc,model,options)
      if the_proc.arity == 2
        the_proc.call(model, options)
      else
        the_proc.call(model)
      end
    end

  end
end
