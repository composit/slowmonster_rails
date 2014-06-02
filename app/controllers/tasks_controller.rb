class TasksController < ApplicationController
  before_filter :require_signed_in_user
  load_and_authorize_resource
  respond_to :json
  respond_to :html, only: :index

  def index
    @tasks = @tasks.includes(:task_times).open.prioritized
    @current_task_times = current_user.current_task_times
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
