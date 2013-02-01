class ReportsController < ApplicationController
  skip_authorization_check only: :show

  def show
    task_contents = ["Date"]
    date_data = {}
    params[:task_ids].split( /\D/ ).each do |task_id|
      unless task_id.blank?
        task = Task.find( task_id )
        task_contents << task.content
        task.totals_over_time( Date.parse( '2012-08-01' ), Date.parse( '2012-09-01' ) ).each do |task_total|
          date_string = task_total[:date].strftime( "%Y-%m-%d" )
          date_data[date_string] ||= []
          date_data[date_string] << task_total[:value]
        end
      end
    end
    columns = date_data.map { |k,v| [k,v].flatten }
    render text: "#{params[:callback]}(#{[task_contents] + columns})"
  end
end
