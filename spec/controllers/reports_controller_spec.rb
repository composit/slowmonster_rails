require 'spec_helper'

describe ReportsController do
  context 'GET show' do
    it 'returns totals over time for a specific task' do
      pending
      task = double
      Task.stub( :find ).with( '123' ) { task }
      task.stub( :totals_over_time ) { [1,5,7,9] }
      get :show, task_ids: '123'
      expect( response.body ).to eq "[1,5,7,9]"
    end

    it 'wraps the response in the callback'
  end
end
