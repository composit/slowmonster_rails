class TasksController < ApplicationController
  before_filter :require_signed_in_user
  load_and_authorize_resource
  respond_to :json

  def create
    @task.user = current_user
    @task.save
    respond_with @task
  end

  def update
    @task.update_attributes params[:task]
    respond_with @task
  end

  def destroy
    @task.destroy
    respond_with :success
  end
end
