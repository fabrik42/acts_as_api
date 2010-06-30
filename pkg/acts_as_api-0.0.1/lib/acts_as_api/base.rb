module ActsAsApi
  # This module enriches the ActiveRecord::Base module of Rails.
  module Base
    # Indicates if the current model acts as api.
    # False by default.
    def acts_as_api?
      false
    end

    # When invoked, it enriches the current model with the
    # class and instance methods to act as api.
    def acts_as_api

      class_eval do
        include ActsAsApi::Base::InstanceMethods
        extend ActsAsApi::Base::ClassMethods
      end

    end

    module ClassMethods

      def acts_as_api?#:nodoc:
        self.included_modules.include?(InstanceMethods)
      end

      # Determines the attributes, methods of the model that are accessible in the api response.
      # *Note*: There is only whitelisting for api accessible attributes.
      # So once the model acts as api, you have to determine all attributes here that should
      # be contained in the api responses.
      def api_accessible(*attributes)
        write_inheritable_attribute(:api_accessible, Set.new(attributes) + (api_accessible_attributes || []))
      end

      # Returns an array of all the attributes that have been made accessible to the api response.
      def api_accessible_attributes
        read_inheritable_attribute(:api_accessible)
      end

    end


    module InstanceMethods

      # Creates the api response of the model and returns it as a Hash.
      def as_api_response
        api_attributes = self.class.api_accessible_attributes

        api_output = {}

        return api_output if api_attributes.nil?

        api_attributes.each do |attribute|

          case attribute
          when Symbol

            if self.respond_to?(attribute)
              out = send attribute

              if out.respond_to?(:as_api_response)
                out = out.send(:as_api_response)
              end

              api_output[attribute] = out

            end

          when Hash

            queue = []
            queue << { :parent =>  api_output, :item => attribute}

            until queue.empty? do

              leaf = queue.pop

              leaf[:item].each do |k,v|

                case v
                when Symbol

                  if self.respond_to?(v)
                    out = send v

                    if out.respond_to?(:as_api_response)
                      out = out.send(:as_api_response)
                    end

                    leaf[:parent][k] = out

                  end

                when Hash
                  leaf[:parent][k] ||= {}
                  queue << { :parent =>  leaf[:parent][k], :item => v}
                end

              end

            end

          end
          
        end

        api_output

      end
      
    end


  end
end