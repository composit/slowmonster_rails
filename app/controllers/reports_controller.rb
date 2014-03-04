class ReportsController < ApplicationController
  before_filter :require_signed_in_user
  load_and_authorize_resource
  respond_to :json

  def show
  end

  def custom
    @tasks = []
    task = Task.find_by_content('exercizer') and @tasks << [task, 5.0]
    task = Task.find_by_content('meditator') and @tasks << [task, 10.0/3.0]
    task = Task.find_by_content('Scout') and @tasks << [task, 40.0]
    task = Task.find_by_content('musics') and @tasks << [task, 4.5]
    task = Task.find_by_content('codez') and @tasks << [task, 19.0/3.0]
    task = Task.find_by_content('Bulley & Andrews') and @tasks << [task, 5.0]
    @color = 'green'
  end
end
