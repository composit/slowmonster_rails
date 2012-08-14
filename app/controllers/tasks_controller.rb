class TasksController < ApplicationController
  respond_to :json

  def index
    @tasks = current_user.tasks
  end
end
