class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization

  protected
    def require_signed_in_user
      redirect_to new_user_session_url, alert: 'Please sign in' unless current_user
    end

    def current_user
      return if cookies[:user_token].nil?
      @current_user ||= User.find_by_auth_token cookies[:user_token]
    end
end
