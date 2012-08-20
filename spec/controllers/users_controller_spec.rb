require 'spec_helper'

describe UsersController do
  context 'not logged in' do
    it 'redirects to the new user session url' do
      get :current_task_time
      response.should redirect_to new_user_session_url
    end

    it 'displays an alert' do
      get :current_task_time
      flash[:alert].should == 'Please sign in'
    end
  end

  context 'logged in' do
    let( :current_user ) { mock_model User }
    let( :current_ability ) { double }

    before :each do
      controller.stub( :current_user ) { current_user }
      current_ability.extend CanCan::Ability
      controller.stub( :current_ability ) { current_ability }
      current_ability.can :manage, User
    end

    context 'GET current_task' do
      it 'returns the current_task' do
        current_task_time = double
        current_user.stub( :current_task_time ) { current_task_time }
        get :current_task_time
        assigns[:current_task_time].should == current_task_time
      end
    end
  end
end
