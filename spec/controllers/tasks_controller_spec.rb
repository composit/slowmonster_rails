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
      let( :tasks_stub ) { double.as_null_object }

      before :each do
        Task.stub( :accessible_by ).with( current_ability, :index ) { tasks_stub }
      end

      it 'returns all tasks accessible by the current user' do
        get :index
        assigns[:tasks].should == tasks_stub
      end

      it 'prioritizes the tasks' do
        tasks_stub.should_receive( :prioritized )
        get :index
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

    context 'PUT reprioritize' do
      it 'updates the task priorities' do
        task_1 = create :task, id: 1
        task_2 = create :task, id: 2
        task_3 = create :task, id: 3
        put :reprioritize, 'tasks' => ['2','3','1']
        [task_1, task_2, task_3].collect { |task| task.reload.priority }.should == [2,0,1]
      end

      it 'does not prioritize tasks that the current user does not have access to' do
        task = create :task, id: 1
        current_ability.cannot :manage, task
        -> {
          put :reprioritize, 'tasks' => ['1']
        }.should raise_error CanCan::AccessDenied
      end
    end

    context 'start' do
      it 'starts the task' do
        task_stub = mock_model Task
        Task.stub( :find ).with( task_stub.id.to_s ) { task_stub }
        task_stub.should_receive( :start )
        put :start, id: task_stub.id
      end

      it 'does not allow a user to start a task they do not have access to' do
        task = create :task
        current_ability.cannot :manage, task
        -> {
          put :start, id: task.id
        }.should raise_error CanCan::AccessDenied
      end
    end
  end
end
