require 'spec_helper'

describe TasksController do
  context 'not logged in' do
    it 'tests'
  end

  context 'logged in' do
    let( :current_user ) { stub }

    before :each do
      controller.stub( :current_user ) { current_user }
    end

    context 'GET index' do
      it 'returns all tasks' do
        tasks_stub = stub
        current_user.stub( :tasks ) { tasks_stub }
        get :index
        assigns[:tasks].should == tasks_stub
      end
    end
  end
end
