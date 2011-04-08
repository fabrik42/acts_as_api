module ActsAsApi
  #
  class ApiTemplate < Hash

    attr_accessor_with_default :options, {}

    def options_for(key)
      options[key]
    end
    
    def option_for(key, value)
      options[key][value] if options[key]
    end

    def add(val, options = {})
      
      item_key = (options[:as] || val).to_sym
      
      self[item_key] = val
      self.options[item_key] = options
    end

    def remove(key)
      self.delete(key)
    end

  end
end
