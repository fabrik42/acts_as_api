module SharedEngine
  class UsersController < SharedEngine::ApplicationController

    def index
      @users = User.all.sort_by(&:first_name)

      respond_to do |format|
        format.xml  { render_for_api params[:api_template].to_sym, :xml => @users, :root => :users }
        format.json { render_for_api params[:api_template].to_sym, :json => @users, :root => :users }
      end
    end

    def index_meta
      @users = User.all
      meta_hash = { :page => 1, :total => 999 }

      respond_to do |format|
        format.xml  { render_for_api params[:api_template].to_sym, :xml => @users, :root => :users,  :meta => meta_hash }
        format.json { render_for_api params[:api_template].to_sym, :json => @users, :root => :users, :meta => meta_hash }
      end
    end
  
    def index_relation
      @users = User.limit(100).sort_by(&:first_name)

      respond_to do |format|
        format.xml  { render_for_api params[:api_template].to_sym, :xml => @users }
        format.json { render_for_api params[:api_template].to_sym, :json => @users }
      end    
    end

    def show
      @user = User.find(params[:id])

      respond_to do |format|
        # :root => :user is only used here because we need it for the node name of the MongoUser model
        format.xml  { render_for_api params[:api_template].to_sym, :xml => @user, :root => :user }
        format.json { render_for_api params[:api_template].to_sym, :json => @user, :root => :user }
      end
    end

    def show_meta
      @user = User.find(params[:id])
      meta_hash = { :page => 1, :total => 999 }
      respond_to do |format|
        # :root => :user is only used here because we need it for the node name of the MongoUser model
        format.xml  { render_for_api params[:api_template].to_sym, :xml => @user, :root => :user }
        format.json { render_for_api params[:api_template].to_sym, :json => @user, :root => :user, :meta => meta_hash }
      end
    end

    def show_default
      @user = User.find(params[:id])
      respond_to do |format|
        format.xml { render :xml => @user }
        format.json { render :json => @user }
      end
    end

    def show_prefix_postfix
      @user = User.find(params[:id])
      template = {:template => params[:api_template], :prefix => params[:api_prefix], :postfix => params[:api_postfix]}
      respond_to do |format|
        # :root => :user is only used here because we need it for the node name of the MongoUser model
        format.xml { render_for_api template, :xml => @user, :root => :user }
        format.json { render_for_api template, :json => @user, :root => :user }
      end
    end

  end
end
