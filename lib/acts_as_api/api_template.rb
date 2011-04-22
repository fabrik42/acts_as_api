module ActsAsApi
  #
  class ApiTemplate < Hash

    attr_accessor :api_template

    def self.create(template)
      t = ApiTemplate.new
      t.api_template = template
      return t
    end

    def add(val, options = {})
      item_key = (options[:as] || val).to_sym

      self[item_key] = val

      @options ||= {}
      @options[item_key] = options
    end

    def remove(attribute)
      self.delete(attribute)
    end

    def options_for(attribute)
      @options[attribute]
    end

    def option_for(attribute, option)
      @options[attribute][option] if @options[attribute]
    end

    def to_response_hash(model)
      queue = []
      api_output = {}
      queue << { :parent =>  api_output, :item => self }

      until queue.empty? do
          leaf = queue.pop

          leaf[:item].each do |k,v|

            if leaf[:item].respond_to?(:option_for)
              sub_template = leaf[:item].option_for(k, :template) || api_template
            else
              sub_template = api_template
            end

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
              out = out.send(:as_api_response, sub_template)
            end

            leaf[:parent][k] = out

          end
        end

        api_output
      end

    end
  end
