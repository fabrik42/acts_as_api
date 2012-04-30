module ActsAsApi

  module Config
    
    class << self

      attr_writer :accepted_api_formats, :dasherize_for, :include_root_in_json_collections, :add_root_node_for, :default_root, :allow_jsonp_callback, :add_http_status_to_jsonp_response
      
      # The accepted response formats
      # Default is <tt>[:xml, :json]</tt>
      def accepted_api_formats
        @accepted_api_formats || [:xml, :json]
      end
        
      # Holds formats that should be dasherized      
      # Default is <tt>[:xml]</tt>    
      def dasherize_for
        @dasherize_for || [:xml]
      end  
      
      # If true, the root node in json collections will be added
      # so the response will look like the default Rails 3 json
      # response
      def include_root_in_json_collections
        @include_root_in_json_collections || false
      end
      
      # Holds references to formats that need
      # to get added an additional root node
      # with the name of the model.
      def add_root_node_for
        @add_root_node_for || [:json]
      end      
      
      # The default name of a root node of a response
      # if no root paramter is passed in render_for_api
      # and the gem is not able to determine a root name
      # automatically    
      def default_root
        @default_root || :record
      end  
      
      # If true a json response will be automatically wrapped into
      # a JavaScript function call in case a :callback param is passed.
      def allow_jsonp_callback
        @allow_jsonp_callback || false
      end
      
      # If true the jsonp function call will get the http status passed
      # as a second parameter
      def add_http_status_to_jsonp_response
        @add_http_status_to_jsonp_response.nil? ? true : @add_http_status_to_jsonp_response
      end
    end
    
  end

end
