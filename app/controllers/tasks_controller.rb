class TasksController < ApplicationController
  before_filter :require_signed_in_user
  load_and_authorize_resource
  respond_to :json
end
