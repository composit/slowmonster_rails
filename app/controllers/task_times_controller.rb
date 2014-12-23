class TaskTimesController < ApplicationController
  before_filter :require_signed_in_user
  load_and_authorize_resource except: :create
  respond_to :json

  def create
    @task_time = TaskTime.new(params[:task_time])
    @task_time.started_at ||= Time.zone.now()
    authorize! :create, @task_time
    @task_time.save!
    respond_with @task_time, location: nil
  end

  def stop
    @task_time.stop
    respond_with :success
  end

  def break
    @task_time.break
    respond_with :success
  end
end
