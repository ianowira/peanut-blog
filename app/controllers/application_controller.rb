# rails generate controller #{ControllerName}

class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_id?
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_id?
    !!current_user
  end
end
