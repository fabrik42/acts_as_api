module SharedEngine
  class RespondWithUsersController < SharedEngine::ApplicationController

    respond_to :json, :xml

    self.responder = ActsAsApi::Responder

    def index
      @users = User.all.sort_by(&:first_name)
      respond_with @users, :api_template => params[:api_template].to_sym, :root => :users
    end

    def index_no_root_no_order
      @users = User.all
      respond_with @users, :api_template => params[:api_template].to_sym
    end
    
    def index_meta
      @users = User.all
      meta_hash = { :page => 1, :total => 999 }
      respond_with @users, :api_template => params[:api_template].to_sym, :root => :users, :meta => meta_hash
    end
  
    def index_relation
      @users = User.limit(100).sort_by(&:first_name)
      respond_with @users, :api_template => params[:api_template].to_sym
    end  

    def show
      @user = User.find(params[:id])
      # :root => :user is only used here because we need it for the node name of the MongoUser model
      respond_with @user, :api_template => params[:api_template].to_sym, :root => :user
    end

    def show_meta
      @user = User.find(params[:id])
      meta_hash = { :page => 1, :total => 999 }
      # :root => :user is only used here because we need it for the node name of the MongoUser model
      respond_with @user, :api_template => params[:api_template].to_sym, :root => :user, :meta => meta_hash
    end

    def show_default
      @user = User.find(params[:id])
      respond_with @user
    end

    def show_prefix_postfix
      @user = User.find(params[:id])
      # :root => :user is only used here because we need it for the node name of the MongoUser model
      respond_with @user, :api_template => {:template => params[:api_template], :prefix => params[:api_prefix], :postfix => params[:api_postfix]}, :root => :user
    end

    def create
      @user = User.new(params[:user])

      if @user.save
        respond_with @user, :api_template => params[:api_template]
      else
        respond_with @user
      end
    end

  end
end
