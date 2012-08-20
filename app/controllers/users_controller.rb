class UsersController < ApplicationController
  before_filter :require_signed_in_user
  load_and_authorize_resource
  respond_to :json

  def current_task_time
    @current_task_time = current_user.current_task_time
    respond_with @current_task_time
  end
end
