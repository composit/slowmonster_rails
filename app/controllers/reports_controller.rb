class ReportsController < ApplicationController
  before_filter :require_signed_in_user
  load_and_authorize_resource
  respond_to :json

  def show
  end

  def custom
    @tasks = []
    @tasks << [Task.find_by_content('exercizer'), 5.0]
    @tasks << [Task.find_by_content('meditator'), 10.0/3.0]
    @tasks << [Task.find_by_content('Scout'), 40.0]
    @tasks << [Task.find_by_content('musics'), 4.5]
    @tasks << [Task.find_by_content('codez'), 19.0/3.0]
    @color = 'green'
  end
end
