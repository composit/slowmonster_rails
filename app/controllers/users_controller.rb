class UsersController < ApplicationController
  before_filter :require_signed_in_user
  load_and_authorize_resource
  respond_to :json

  def current_task
    @current_task = current_user.current_task_time.task
    respond_with @current_task
  end
end
