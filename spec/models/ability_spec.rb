require 'spec_helper'
require 'cancan/matchers'

describe Ability do
  subject { ability }
  let( :user ) { create :user }
  let( :ability ) { Ability.new user }

  context 'tasks' do
    context 'belong to user' do
      let( :task ) { build :task, user: user }

      specify { expect( ability ).to be_able_to :create, task }
      specify { expect( ability ).to be_able_to :read, task }
      specify { expect( ability ).to be_able_to :update, task }
      specify { expect( ability ).to be_able_to :destroy, task }
    end

    context 'do not belong to user' do
      let( :task ) { build :task }

      specify { expect( ability ).to_not be_able_to :create, task }
      specify { expect( ability ).to_not be_able_to :read, task }
      specify { expect( ability ).to_not be_able_to :update, task }
      specify { expect( ability ).to_not be_able_to :destroy, task }
    end
  end

  context 'users' do
    context 'is the user' do
      specify { expect( ability ).to be_able_to :create, user }
      specify { expect( ability ).to be_able_to :read, user }
      specify { expect( ability ).to be_able_to :update, user }
      specify { expect( ability ).to be_able_to :destroy, user }
    end

    context 'is not the user' do
      let( :other_user ) { build :user }

      specify { expect( ability ).to_not be_able_to :create, other_user }
      specify { expect( ability ).to_not be_able_to :read, other_user }
      specify { expect( ability ).to_not be_able_to :update, other_user }
      specify { expect( ability ).to_not be_able_to :destroy, other_user }
    end
  end

  context 'task_joiners' do
    context 'belong to user' do
      let( :parent_task ) { build :task, user: user }
      let( :child_task ) { build :task, user: user }
      let( :task_joiner ) { build :task_joiner, parent_task: parent_task, child_task: child_task }

      specify { expect( ability ).to be_able_to :create, task_joiner }
      specify { expect( ability ).to be_able_to :read, task_joiner }
      specify { expect( ability ).to be_able_to :update, task_joiner }
      specify { expect( ability ).to be_able_to :destroy, task_joiner }
    end

    context 'do not belong to the user' do
      let( :task_joiner ) { build :task_joiner }

      specify { expect( ability ).to_not be_able_to :create, task_joiner }
      specify { expect( ability ).to_not be_able_to :read, task_joiner }
      specify { expect( ability ).to_not be_able_to :update, task_joiner }
      specify { expect( ability ).to_not be_able_to :destroy, task_joiner }
    end
  end

  context 'task_times' do
    context 'belong to user' do
      let( :task ) { build :task, user: user }
      let( :task_time ) { build :task_time, task: task }

      specify { expect( ability ).to be_able_to :create, task_time }
      specify { expect( ability ).to be_able_to :read, task_time }
      specify { expect( ability ).to be_able_to :update, task_time }
      specify { expect( ability ).to be_able_to :destroy, task_time }
    end

    context 'do not belong to the user' do
      let( :task_time ) { build :task_time }

      specify { expect( ability ).to_not be_able_to :create, task_time }
      specify { expect( ability ).to_not be_able_to :read, task_time }
      specify { expect( ability ).to_not be_able_to :update, task_time }
      specify { expect( ability ).to_not be_able_to :destroy, task_time }
    end
  end

  it 'cannot access reports with tasks of other users' do
    raise 'not implemented'
  end
end
