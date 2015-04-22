class UserSessionsController < ApplicationController
  skip_authorization_check
  respond_to :html

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    @user = User.where( username: @user_session.username ).first
    if @user && @user.authenticate( @user_session.password )
      token = @user.create_auth_token!
      if(@user_session.remember_me)
        cookies.permanent.signed[:user_token] = { value: token, secure: Rails.env.production? }
      else
        cookies.signed[:user_token] = token
      end
      redirect_to root_url
    else
      flash.now[:error] = 'invalid username or password'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    auth_token = AuthToken.find_by_token(cookies.signed[:user_token])
    auth_token.destroy
    cookies.delete :user_token
    redirect_to root_url
  end
end
