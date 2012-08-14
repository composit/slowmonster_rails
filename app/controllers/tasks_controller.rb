class TasksController < ApplicationController
  load_and_authorize_resource
  respond_to :json
end
