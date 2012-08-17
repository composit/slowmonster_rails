class TasksController < ApplicationController
  before_filter :require_signed_in_user
  load_and_authorize_resource
  respond_to :json
  respond_to :html, only: :index

  def index
    @tasks = @tasks.prioritized
    respond_with @tasks
  end

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

  def reprioritize
    params[:tasks].each_with_index do |task_id, index|
      task = Task.find( task_id )
      authorize! :update, task
      task.priority = index
      task.save!
    end
    respond_with :success
  end

  def start
    @task.start
    respond_with :success
  end
end
