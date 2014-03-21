class UserSessionsController < ApplicationController
  skip_authorization_check
  respond_to :json

  def new
  end

  def create
    #TODO location should not be needed in the response
    @user = User.where( username: params[:user_session][:username] ).first
    if @user && @user.authenticate( params[:user_session][:password] )
      if(params[:user_session][:remember_me])
        cookies.permanent[:user_id] = @user.id
      else
        cookies[:user_id] = @user.id
      end
      respond_with @user, location: root_url
    else
      respond_with ["invalid username or password"], status: :unprocessable_entity, location: root_url
    end
  end

  def destroy
    cookies.delete :user_id
    respond_with true
  end
end
