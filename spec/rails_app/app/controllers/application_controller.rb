class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter do
    if params[:orm] == :active_record
      @user_model = User
    elsif params[:orm] == :mongoid
      @user_model = MongoUser
    end
  end
end
