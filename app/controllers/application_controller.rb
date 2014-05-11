class ApplicationController < ActionController::Base
  protect_from_forgery
  check_authorization

  after_filter :set_csrf_cookie_for_ng

  protected
    def require_signed_in_user
      redirect_to new_user_session_url, alert: 'Please sign in' unless current_user
    end

    def current_user
      return if cookies[:user_token].nil?
      @current_user ||= User.find_by_auth_token cookies[:user_token]
    end

    def set_csrf_cookie_for_ng
      cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
    end

    def verified_request?
      super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
    end
end
