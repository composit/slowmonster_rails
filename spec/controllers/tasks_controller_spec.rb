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
    let( :current_user ) { mock_model User, current_task_times: :current_task_times_stub }
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
        tasks_stub.should_receive :prioritized
        get :index
      end

      it 'returns open tasks' do
        tasks_stub.should_receive :open
        get :index
      end
    end

    context 'POST create' do
      it 'sets the user' do
        post :create, 'task' => { 'content' => 'test content', 'days_in_week' => 7 }
        expect( assigns[:task].reload.user_id ).to eq current_user.id
      end
      
      it 'creates a new task' do
        expect {
          post :create, 'task' => { 'content' => 'test content', 'days_in_week' => 7 }
        }.to change( Task, 'count' ).from( 0 ).to 1
      end

      it 'sets the attributes of the new task' do
        post :create, 'task' => { 'content' => 'test content', 'days_in_week' => 7 }
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

    context 'PUT add amount' do
      context 'on success' do
        let(:task_stub) { mock_model Task, add_amount: true, total_value: 123 }

        before do
          Task.stub(:find).with(task_stub.id.to_s) { task_stub }
        end

        it 'adds an amount to the task' do
          task_stub.should_receive(:add_amount).with('123')
          put :add_amount, id: task_stub.id, amount: '123', format: :json
        end

        it 'returns the total amount for that task for that day' do
          task_stub.should_receive(:total_value).with(Time.now.beginning_of_day, nil) { :total_today_stub }
          put :add_amount, id: task_stub.id, amount: '123', format: :json
          expect(response.body).to eq({ total_today: :total_today_stub }.to_json)
        end
      end

      it 'does not allow a user to add an amount to a task they do not have access to' do
        task = create :task
        current_ability.cannot :manage, task
        expect {
          put :add_amount, id: task.id, amount: 123
        }.to raise_error CanCan::AccessDenied
      end
    end
  end
end
