require 'spec_helper'

describe TasksController do
  context 'not logged in' do
    it 'redirects to the new user session url' do
      get :index
      expect( response ).to redirect_to new_user_session_url
    end

    it 'displays an alert' do
      get :index
      expect( flash[:alert] ).to eq 'Please sign in'
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
        expect( assigns[:tasks] ).to eq tasks_stub
      end

      it 'prioritizes the tasks' do
        tasks_stub.should_receive( :prioritized )
        get :index
      end
    end

    context 'POST create' do
      it 'sets the user' do
        post :create, 'task' => { 'content' => 'test content' }
        expect( assigns[:task].reload.user_id ).to eq current_user.id
      end
      
      it 'creates a new task' do
        expect {
          post :create, 'task' => { 'content' => 'test content' }
        }.to change( Task, 'count' ).from( 0 ).to 1
      end

      it 'sets the attributes of the new task' do
        post :create, 'task' => { 'content' => 'test content' }
        expect( assigns[:task].reload.content ).to eq 'test content'
      end
    end

    context 'PUT update' do
      it 'updates the task' do
        task = create :task
        put :update, id: task.id, 'task' => { 'content' => 'new content' }
        expect( task.reload.content ).to eq 'new content'
      end
    end

    context 'DELETE destroy' do
      it 'deletes the task' do
        task = create :task
        delete :destroy, id: task.id
        expect( Task.find_by_id task.id ).to be_nil
      end
    end

    context 'PUT reprioritize' do
      it 'updates the task priorities' do
        task_1 = create :task, id: 1
        task_2 = create :task, id: 2
        task_3 = create :task, id: 3
        put :reprioritize, 'tasks' => ['2','3','1']
        expect( [task_1, task_2, task_3].collect { |task| task.reload.priority } ).to eq [2,0,1]
      end

      it 'does not prioritize tasks that the current user does not have access to' do
        task = create :task, id: 1
        current_ability.cannot :manage, task
        expect {
          put :reprioritize, 'tasks' => ['1']
        }.to raise_error CanCan::AccessDenied
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
        expect {
          put :start, id: task.id
        }.to raise_error CanCan::AccessDenied
      end
    end

    context 'close' do
      it 'closes the task' do
        task_stub = mock_model Task
        Task.stub( :find ).with( task_stub.id.to_s ) { task_stub }
        task_stub.should_receive( :close )
        put :close, id: task_stub.id
      end

      it 'does not allow a user to close a task they do not have access to' do
        task = create :task
        current_ability.cannot :manage, task
        expect {
          put :close, id: task.id
        }.to raise_error CanCan::AccessDenied
      end
    end
  end
end
