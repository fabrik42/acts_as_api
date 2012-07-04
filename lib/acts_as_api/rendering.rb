module ActsAsApi

  # The methods of this module are included into the AbstractController::Rendering
  # module.
  module Rendering

    # Provides an alternative to the +render+ method used within the controller
    # to simply generate API outputs.
    #
    # The default Rails serializers are used to serialize the data.
    def render_for_api(api_template_or_options, render_options)
      if api_template_or_options.is_a?(Hash)
        api_template = []
        api_template << api_template_or_options.delete(:prefix)
        api_template << api_template_or_options.delete(:template)
        api_template << api_template_or_options.delete(:postfix)
        api_template = api_template.reject(&:blank?).join('_')
      else
        api_template = api_template_or_options
      end

      # extract the api format and model
      api_format_options = {}

      ActsAsApi::Config.accepted_api_formats.each do |item|
        if render_options.has_key?(item)
          api_format_options[item] = render_options[item]
          render_options.delete item
        end
      end

      meta_hash = render_options[:meta] if render_options.has_key?(:meta)

      api_format =  api_format_options.keys.first
      api_model  =  api_format_options.values.first

      # set the params to render
      output_params = render_options

      api_root_name = nil

      if !output_params[:root].nil?
        api_root_name = output_params[:root].to_s
      elsif api_model.class.respond_to?(:model_name)        
        api_root_name = api_model.class.model_name        
      elsif api_model.respond_to?(:collection_name)
        api_root_name = api_model.collection_name
      elsif api_model.is_a?(Array) && !api_model.empty? && api_model.first.class.respond_to?(:model_name)
        api_root_name = api_model.first.class.model_name
      elsif api_model.respond_to?(:model_name)
        api_root_name = api_model.model_name        
      else
        api_root_name = ActsAsApi::Config.default_root.to_s
      end

      api_root_name = api_root_name.to_s.underscore.tr('/', '_')

      if api_model.is_a?(Array) || (defined?(ActiveRecord) && api_model.is_a?(ActiveRecord::Relation))
        api_root_name = api_root_name.pluralize
      end

      api_root_name = api_root_name.dasherize if ActsAsApi::Config.dasherize_for.include? api_format.to_sym

      output_params[:root] = api_root_name

      #output_params[:root] = output_params[:root].camelize if render_options.has_key?(:camelize) && render_options[:camelize]
      #output_params[:root] = output_params[:root].dasherize if !render_options.has_key?(:dasherize) || render_options[:dasherize]

      api_response = api_model.as_api_response(api_template)

      if api_response.is_a?(Array) && api_format.to_sym == :json && ActsAsApi::Config.include_root_in_json_collections
        api_response = api_response.collect{|f| { api_root_name.singularize => f } }
      end

      if meta_hash or ActsAsApi::Config.add_root_node_for.include? api_format
        api_response = { api_root_name.to_sym =>  api_response}
      end

      api_response = meta_hash.merge api_response if meta_hash
      
      if ActsAsApi::Config.allow_jsonp_callback && params[:callback]
        output_params[:callback] = params[:callback]
        api_format = :acts_as_api_jsonp if ActsAsApi::Config.add_http_status_to_jsonp_response
      end

      # create the Hash as response
      output_params[api_format] = api_response

      render output_params
    end

  end

end
