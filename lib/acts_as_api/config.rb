module ActsAsApi

  module Config

    # The accepted response formats
    # Default is +[:xml, :json]+
    ACCEPTED_API_FORMATS = [:xml, :json]

    # Holds formats that should be dasherized
    DASHERIZE_FOR = [:xml]

    # Holds references to formats that need
    # to get added an additional root node
    # with the name of the model.
    ADD_ROOT_NODE_FOR = [:json]

    # The default name of a root node of a response
    # if no root paramter is passed in render_for_api
    # and the gem is not able to determine a root name
    # automatically
    DEFAULT_ROOT = :record

    mattr_accessor :accepted_api_formats
    mattr_accessor :dasherize_for
    mattr_accessor :add_root_node_for
    mattr_accessor :default_root

    @@accepted_api_formats = ACCEPTED_API_FORMATS
    @@dasherize_for        = DASHERIZE_FOR
    @@add_root_node_for    = ADD_ROOT_NODE_FOR
    @@default_root         = DEFAULT_ROOT

  end

end