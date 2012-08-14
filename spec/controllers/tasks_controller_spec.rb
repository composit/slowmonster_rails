require 'spec_helper'

describe TasksController do
  context 'not logged in' do
    it 'redirects to the new user session url' do
      get :index
      response.should redirect_to new_user_session_url
    end

    it 'displays an alert' do
      get :index
      flash[:alert].should == 'Please sign in'
    end
  end

  context 'logged in' do
    let( :current_user ) { double }
    let( :current_ability ) { double }

    before :each do
      controller.stub( :current_user ) { current_user }
      current_ability.extend CanCan::Ability
      controller.stub( :current_ability ) { current_ability }
      current_ability.can :manage, Task
    end

    context 'GET index' do
      it 'returns all tasks accessible by the current user' do
        tasks_stub = double
        Task.stub( :accessible_by ).with( current_ability, :index ) { tasks_stub }
        get :index
        assigns[:tasks].should == tasks_stub
      end
    end
  end
end
