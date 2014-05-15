require 'spec_helper'

describe TaskTimesController do
  context 'not logged in' do
    it 'redirects to the new user session url' do
      put :stop, id: 1
      expect( response ).to redirect_to new_user_session_url
    end

    it 'displays an alert' do
      put :stop, id: 1
      expect( flash[:alert] ).to eq 'Please sign in'
    end
  end

  context 'logged in' do
    let( :current_user ) { mock_model User, current_task_time: :current_task_time_stub }
    let( :current_ability ) { double }
    let(:task) { create(:task) }
    let(:task_time_attributes) { attributes_for(:task_time).merge({ task_id: task.id }) }

    before :each do
      controller.stub( :current_user ) { current_user }
      current_ability.extend CanCan::Ability
      controller.stub( :current_ability ) { current_ability }
      current_ability.can :manage, TaskTime
    end

    context 'create' do
      it 'creates a new task_time' do
        expect {
          post :create, 'task_time' => task_time_attributes
        }.to change(TaskTime, 'count').from(0).to 1
      end

      it 'sets the attributes of the new task_time' do
        post :create, 'task_time' => task_time_attributes
        expect(assigns[:task_time].reload.task_id).to eq task.id
      end

      it 'defaults the started_at attribute to the current time' do
        post :create, 'task_time' => task_time_attributes.merge({ started_at: nil })
        expect(assigns[:task_time].reload.started_at).to be_within(1.second).of Time.zone.now
      end

      it 'does not allow a user to create a task time they do not have access to' do
        current_ability.cannot :manage, TaskTime
        expect {
          post :create, task_id: 123
        }.to raise_error CanCan::AccessDenied
      end
    end

    context 'stop' do
      it 'stops the task_time' do
        task_time_stub = mock_model TaskTime
        TaskTime.stub( :find ).with( task_time_stub.id.to_s ) { task_time_stub }
        task_time_stub.should_receive( :stop )
        put :stop, id: task_time_stub.id
      end

      it 'does not allow a user to stop a task time they do not have access to' do
        task_time = create :task_time
        current_ability.cannot :manage, task_time
        expect {
          put :stop, id: task_time.id
        }.to raise_error CanCan::AccessDenied
      end
    end
  end
end
