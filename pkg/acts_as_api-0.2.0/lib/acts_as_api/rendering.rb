module ActsAsApi

  # The methods of this module are included into the AbstractController::Rendering
  # module.
  module Rendering

    # Provides an alternative to the +render+ method used within the controller
    # to simply generate API outputs.
    #
    # The default Rails serializers are used to serialize the data.
    def render_for_api(api_template, render_options)

      # extract the api format and model
      api_format_options = {}

      ActsAsApi::ACCEPTED_API_FORMATS.each do |item|
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

      elsif api_model.respond_to?(:model_name)
        api_root_name = api_model.model_name
      elsif api_model.is_a?(Array) && !api_model.empty? && api_model.first.class.respond_to?(:model_name)
        api_root_name = api_model.first.class.model_name
      elsif api_model.class.respond_to?(:model_name)
        api_root_name = api_model.class.model_name
      else
        api_root_name = ActsAsApi::DEFAULT_ROOT.to_s
      end

      api_root_name = api_root_name.underscore.tr('/', '_')

      if api_model.is_a?(Array)
        api_root_name = api_root_name.pluralize
      end

      api_root_name = api_root_name.dasherize if ActsAsApi::DASHERIZE_FOR.include? api_format.to_sym

      output_params[:root] = api_root_name

      #output_params[:root] = output_params[:root].camelize if render_options.has_key?(:camelize) && render_options[:camelize]
      #output_params[:root] = output_params[:root].dasherize if !render_options.has_key?(:dasherize) || render_options[:dasherize]

      api_response = api_model.as_api_response(api_template)

      if meta_hash or ActsAsApi::ADD_ROOT_NODE_FOR.include? api_format
        api_response = { api_root_name.to_sym =>  api_response}
      end

      api_response = meta_hash.merge api_response if meta_hash

      # create the Hash as response
      output_params[api_format] = api_response

      render output_params

    end

  end

end