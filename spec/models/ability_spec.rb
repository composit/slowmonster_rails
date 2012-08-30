require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  subject { ability }
  let( :user ) { create :user }
  let( :ability ) { Ability.new user }

  context 'tasks' do
    context 'belong to user' do
      let( :task ) { build :task, user: user }

      specify { ability.should be_able_to :create, task }
      specify { ability.should be_able_to :read, task }
      specify { ability.should be_able_to :update, task }
      specify { ability.should be_able_to :destroy, task }
    end

    context 'do not belong to user' do
      let( :task ) { build :task }

      specify { ability.should_not be_able_to :create, task }
      specify { ability.should_not be_able_to :read, task }
      specify { ability.should_not be_able_to :update, task }
      specify { ability.should_not be_able_to :destroy, task }
    end
  end

  context 'users' do
    context 'is the user' do
      specify { ability.should be_able_to :create, user }
      specify { ability.should be_able_to :read, user }
      specify { ability.should be_able_to :update, user }
      specify { ability.should be_able_to :destroy, user }
    end

    context 'is not the user' do
      let( :other_user ) { build :user }

      specify { ability.should_not be_able_to :create, other_user }
      specify { ability.should_not be_able_to :read, other_user }
      specify { ability.should_not be_able_to :update, other_user }
      specify { ability.should_not be_able_to :destroy, other_user }
    end
  end

  context 'task_joiners' do
    context 'belong to user' do
      let( :parent_task ) { build :task, user: user }
      let( :child_task ) { build :task, user: user }
      let( :task_joiner ) { build :task_joiner, parent_task: parent_task, child_task: child_task }

      specify { ability.should be_able_to :create, task_joiner }
      specify { ability.should be_able_to :read, task_joiner }
      specify { ability.should be_able_to :update, task_joiner }
      specify { ability.should be_able_to :destroy, task_joiner }
    end

    context 'do not belong to the user' do
      let( :task_joiner ) { build :task_joiner }

      specify { ability.should_not be_able_to :create, task_joiner }
      specify { ability.should_not be_able_to :read, task_joiner }
      specify { ability.should_not be_able_to :update, task_joiner }
      specify { ability.should_not be_able_to :destroy, task_joiner }
    end
  end
end
