module ActsAsApi
  # Contains rails specific renderers used by acts_as_api to render a jsonp response
  #
  # See ActsAsApi::Config about the possible configurations
  module RailsRenderer

    def self.setup
      ActionController.add_renderer :acts_as_api_jsonp do |json, options|
        json = ActiveSupport::JSON.encode(json) unless json.respond_to?(:to_str)

        if options[:callback].present?
          json = "#{options[:callback]}(#{json}, #{response.status})"
          self.content_type = Mime[:js]
        end

        self.response_body = json
      end
    end

  end
end
