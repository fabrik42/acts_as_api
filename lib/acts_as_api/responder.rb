module ActsAsApi
  # A custom Rails responder class to automatically use render_for_api in your
  # controller actions.
  #
  # Example:
  #
  #  class UsersController < ApplicationController
  #    # Set this controller to use our custom responder
  #    # (This could be done in a base controller class, if desired)
  #    self.responder = ActsAsApi::Responder
  #
  #    respond_to :json, :xml
  #
  #    def index
  #      @users = User.all
  #      respond_with @users, :api_template => :name_only
  #    end
  #  end
  #
  # The `:api_template` parameter is required so the responder knows which api template it should render.

  class Responder < ActionController::Responder

    # Should be specified as an option to the `respond_with` call
    attr_reader :api_template

    # Grabs the required :api_template parameter, then hands control back to
    # the base ActionController::Responder initializer.
    def initialize(controller, resources, options={})
      @api_template = options.delete(:api_template)
      super(controller, resources, options)
    end

    # Overrides the base implementation of display, replacing it with
    # the render_for_api method whenever api_template is specified.
    def display(resource, given_options={})
      if api_template.nil? || !resource.respond_to?(:as_api_response)
        controller.render given_options.merge!(options).merge!(format => resource)
      else
        controller.render_for_api api_template, given_options.merge!(options).merge!(format => resource)
      end
    end

  end
end
