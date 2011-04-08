module ActsAsApi

  module Config
    
    class << self

      # The accepted response formats
      # Default is <tt>[:xml, :json]</tt>
      attr_accessor_with_default :accepted_api_formats, [:xml, :json] # :nodoc:

      # Holds formats that should be dasherized      
      # Default is <tt>[:xml]</tt>      
      attr_accessor_with_default :dasherize_for, [:xml]
      
      # Holds references to formats that need
      # to get added an additional root node
      # with the name of the model.      
      attr_accessor_with_default :add_root_node_for, [:json]
      
      # The default name of a root node of a response
      # if no root paramter is passed in render_for_api
      # and the gem is not able to determine a root name
      # automatically      
      attr_accessor_with_default :default_root, :record
      
      attr_accessor_with_default :allow_jsonp_callback, false
      
      attr_accessor_with_default :add_http_status_to_jsonp_response, true      

    end
    
  end

end