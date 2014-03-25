class UserSessionsController < ApplicationController
  skip_authorization_check
  respond_to :json

  def new
  end

  def create
    #TODO location should not be needed in the response
    @user = User.where( username: params[:user_session][:username] ).first
    if @user && @user.authenticate( params[:user_session][:password] )
      token = @user.update_auth_token!
      if(params[:user_session][:remember_me])
        cookies[:user_token] = { value: token, secure: Rails.env.production?, expires: 1.week.since }
      else
        cookies[:user_token] = token
      end
      respond_with @user, location: root_url
    else
      respond_with ["invalid username or password"], status: :unprocessable_entity, location: root_url
    end
  end

  def destroy
    cookies.delete :user_token
    respond_with true
  end
end
