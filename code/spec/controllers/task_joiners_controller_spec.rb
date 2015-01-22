require 'spec_helper'

describe TaskJoinersController do
  context 'not logged in' do
    it 'redirects to the new user session url' do
      delete :destroy, id: 123
      expect( response ).to redirect_to new_user_session_url
    end

    it 'displays an alert' do
      delete :destroy, id: 123
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
      current_ability.can :manage, TaskJoiner
    end

    context 'POST create' do
      let( :child_task ) { create :task }
      let( :parent_task ) { create :task }
      let( :attributes ) { { 'child_task_id' => child_task.id.to_s, 'parent_task_id' => parent_task.id.to_s, 'multiplier' => '123' } }

      it 'creates a new task_joiner' do
        expect {
          post :create, 'task_joiner' => attributes
        }.to change( TaskJoiner, 'count' ).from( 0 ).to 1
      end

      it 'sets the attributes of the new task' do
        post :create, 'task_joiner' => attributes
        expect( assigns[:task_joiner].reload.multiplier ).to eq 123
      end
    end

    context 'DELETE destroy' do
      it 'deletes the task joiner' do
        task_joiner = create :task_joiner
        delete :destroy, id: task_joiner.id
        expect( TaskJoiner.find_by_id( task_joiner.id ) ).to be_nil
      end
    end
  end
end
