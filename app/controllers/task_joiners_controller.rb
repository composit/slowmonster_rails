class TaskJoinersController < ApplicationController
  before_filter :require_signed_in_user
  load_and_authorize_resource
  respond_to :json

  def create
    @task_joiner.save!
    respond_with @task_joiner
  end

  def destroy
    @task_joiner.destroy
    respond_with :success
  end
end
