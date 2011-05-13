class RespondWithUsersController < ApplicationController

  respond_to :json, :xml

  self.responder = ActsAsApi::Responder

  def index
    @users = User.all
    respond_with @users, :api_template => params[:api_template].to_sym, :root => :users
  end

  def show
    @user = User.find(params[:id])
    respond_with @user, :api_template => params[:api_template].to_sym
  end

end
