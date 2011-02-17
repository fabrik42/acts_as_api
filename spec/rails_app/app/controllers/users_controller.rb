class UsersController < ApplicationController
  
  def index
    @users = User.all

    respond_to do |format|
      format.xml  { render_for_api params[:api_template].to_sym, :xml => @users, :root => :users }
      format.json { render_for_api params[:api_template].to_sym, :json => @users, :root => :users }
    end
  end
  
  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.xml  { render_for_api params[:api_template].to_sym, :xml => @user }
      format.json { render_for_api params[:api_template].to_sym, :json => @user }
    end
  end  
  
end
