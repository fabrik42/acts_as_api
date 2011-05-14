class RespondWithUsersController < ApplicationController

  respond_to :json, :xml

  self.responder = ActsAsApi::Responder
  
  before_filter do
    if params[:orm] == :active_record
      @user_model = User
    elsif params[:orm] == :mongoid
      @user_model = MongoUser
    end
  end

  def index
    @users = @user_model.all
    respond_with @users, :api_template => params[:api_template].to_sym, :root => :users
  end

  def show
    @user = @user_model.find(params[:id])
    # :root => :user is only used here because we need it for the node name of the MongoUser model
    respond_with @user, :api_template => params[:api_template].to_sym, :root => :user
  end

end
