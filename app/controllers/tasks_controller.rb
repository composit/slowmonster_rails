class TasksController < ApplicationController
  before_filter :require_signed_in_user
  load_and_authorize_resource
  respond_to :json
  respond_to :html, only: :index

  def index
    @tasks = @tasks.open.prioritized
    @current_task_time = current_user.current_task_time
    respond_with @tasks
  end

  def create
    @task.user = current_user
    @task.save!
    respond_with @task
  end

  def update
    @task.update_attributes! params[:task]
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

  def close
    @task.close
    respond_with :success
  end

  def add_amount
    @task.add_amount(params[:amount])
    total_today = @task.total_value(Time.now.beginning_of_day, nil)
    render text: {total_today: total_today}.to_json, status: :ok
  end
end
