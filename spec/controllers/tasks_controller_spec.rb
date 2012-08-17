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
    let( :current_user ) { mock_model User }
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

    context 'POST create' do
      it 'sets the user' do
        post :create, 'task' => { 'content' => 'test content' }
        assigns[:task].reload.user_id.should == current_user.id
      end
      
      it 'creates a new task' do
        -> {
          post :create, 'task' => { 'content' => 'test content' }
        }.should change( Task, 'count' ).from( 0 ).to 1
      end

      it 'sets the attributes of the new task' do
        post :create, 'task' => { 'content' => 'test content' }
        assigns[:task].reload.content.should == 'test content'
      end
    end

    context 'PUT update' do
      it 'updates the task' do
        task = create :task
        put :update, id: task.id, 'task' => { 'content' => 'new content' }
        task.reload.content.should == 'new content'
      end
    end

    context 'DELETE destroy' do
      it 'deletes the task' do
        task = create :task
        delete :destroy, id: task.id
        Task.find_by_id( task.id ).should be_nil
      end
    end
  end
end
