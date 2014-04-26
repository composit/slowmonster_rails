class UserSessionsController < ApplicationController
  skip_authorization_check
  respond_to :json, only: :destroy
  respond_to :html, only: [:new, :create]

  def new
    @user_session = UserSession.new
  end

  def create
    #TODO location should not be needed in the response
    @user_session = UserSession.new(params[:user_session])
    @user = User.where( username: @user_session.username ).first
    if @user && @user.authenticate( @user_session.password )
      token = @user.auth_token || @user.update_auth_token!
      if(@user_session.remember_me)
        cookies[:user_token] = { value: token, secure: Rails.env.production?, expires: 1.week.since }
      else
        cookies[:user_token] = token
      end
      respond_with @user, location: root_url
    else
      flash.now[:error] = 'invalid username or password'
      render :new
    end
  end

  def destroy
    cookies.delete :user_token
    respond_with true
  end
end
