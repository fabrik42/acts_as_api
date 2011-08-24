class UsersController < ApplicationController

  def index
    @users = @user_model.all

    respond_to do |format|
      format.xml  { render_for_api params[:api_template].to_sym, :xml => @users, :root => :users }
      format.json { render_for_api params[:api_template].to_sym, :json => @users, :root => :users }
    end
  end

  def index_meta
    @users = @user_model.all
    meta_hash = { :page => 1, :total => 999 }

    respond_to do |format|
      format.xml  { render_for_api params[:api_template].to_sym, :xml => @users, :root => :users,  :meta => meta_hash }
      format.json { render_for_api params[:api_template].to_sym, :json => @users, :root => :users, :meta => meta_hash }
    end
  end

  def show
    @user = @user_model.find(params[:id])

    respond_to do |format|
      # :root => :user is only used here because we need it for the node name of the MongoUser model
      format.xml  { render_for_api params[:api_template].to_sym, :xml => @user, :root => :user }
      format.json { render_for_api params[:api_template].to_sym, :json => @user, :root => :user }
    end
  end

  def show_meta
    @user = @user_model.find(params[:id])
    meta_hash = { :page => 1, :total => 999 }
    respond_to do |format|
      # :root => :user is only used here because we need it for the node name of the MongoUser model
      format.xml  { render_for_api params[:api_template].to_sym, :xml => @user, :root => :user }
      format.json { render_for_api params[:api_template].to_sym, :json => @user, :root => :user, :meta => meta_hash }
    end
  end

  def show_default
    @user = @user_model.find(params[:id])
    respond_to do |format|
      format.xml { render :xml => @user }
      format.json { render :json => @user }
    end
  end

end