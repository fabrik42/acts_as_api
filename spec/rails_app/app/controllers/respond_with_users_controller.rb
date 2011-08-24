class RespondWithUsersController < ApplicationController

  respond_to :json, :xml

  self.responder = ActsAsApi::Responder

  def index
    @users = @user_model.all
    respond_with @users, :api_template => params[:api_template].to_sym, :root => :users
  end

  def index_meta
    @users = @user_model.all
    meta_hash = { :page => 1, :total => 999 }
    respond_with @users, :api_template => params[:api_template].to_sym, :root => :users, :meta => meta_hash
  end

  def show
    @user = @user_model.find(params[:id])
    # :root => :user is only used here because we need it for the node name of the MongoUser model
    respond_with @user, :api_template => params[:api_template].to_sym, :root => :user
  end

  def show_meta
    @user = @user_model.find(params[:id])
    meta_hash = { :page => 1, :total => 999 }
    # :root => :user is only used here because we need it for the node name of the MongoUser model
    respond_with @user, :api_template => params[:api_template].to_sym, :root => :user, :meta => meta_hash
  end

  def show_default
    @user = @user_model.find(params[:id])
    respond_with @user
  end

  def create
    @user = @user_model.new(params[:user])

    if @user.save
      respond_with @user, :api_template => params[:api_template]
    else
      respond_with @user
    end
  end

end
