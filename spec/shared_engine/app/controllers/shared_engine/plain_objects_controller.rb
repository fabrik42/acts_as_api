module SharedEngine
  class PlainObjectsController < SharedEngine::ApplicationController
    before_filter :setup_objects

    def index
      @users = [@han, @luke, @leia]

      respond_to do |format|
        format.xml  { render_for_api params[:api_template].to_sym, :xml => @users }
        format.json { render_for_api params[:api_template].to_sym, :json => @users }
      end
    end
  end
end
