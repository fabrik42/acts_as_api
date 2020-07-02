# frozen_string_literal: true

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

      yield ActsAsApi::Config if block_given?
    end

    module ClassMethods
      def acts_as_api? #:nodoc:
        included_modules.include?(InstanceMethods)
      end

      # Determines the attributes, methods of the model that are accessible in the api response.
      # *Note*: There is only whitelisting for api accessible attributes.
      # So once the model acts as api, you have to determine all attributes here that should
      # be contained in the api responses.
      def api_accessible(api_template, options = {}, &block)
        attributes = api_accessible_attributes(api_template).try(:dup) || ApiTemplate.new(api_template)
        attributes.merge!(api_accessible_attributes(options[:extend])) if options[:extend]

        yield attributes if block_given?

        class_attribute "api_accessible_#{api_template}".to_sym
        send "api_accessible_#{api_template}=", attributes
      end

      # Returns an array of all the attributes that have been made accessible to the api response.
      def api_accessible_attributes(api_template)
        begin send "api_accessible_#{api_template}".to_sym rescue nil end
      end
    end

    module InstanceMethods
      # Creates the api response of the model and returns it as a Hash.
      # Will raise an exception if the passed api template is not defined for the model
      def as_api_response(api_template, options = {})
        api_attributes = self.class.api_accessible_attributes(api_template)

        if api_attributes.nil?
          raise ActsAsApi::TemplateNotFoundError,
                "acts_as_api template :#{api_template} was not found for model #{self.class}"
        end

        before_api_response(api_template)
        response_hash = around_api_response(api_template) do
          api_attributes.to_response_hash(self, api_attributes, options)
        end
        after_api_response(api_template)

        response_hash
      end

      protected

      def before_api_response(_api_template); end

      def after_api_response(_api_template); end

      def around_api_response(_api_template)
        yield
      end
    end
  end
end
