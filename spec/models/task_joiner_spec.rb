require 'spec_helper'

describe TaskJoiner do
  specify { build( :task_joiner ).should be_valid }

  it 'requires a parent task' do
    task_joiner = build :task_joiner, parent_task: nil
    task_joiner.should_not be_valid
    task_joiner.errors.full_messages.should == ['Parent task can\'t be blank']
  end

  it 'requires a child task' do
    task_joiner = build :task_joiner, child_task: nil
    task_joiner.should_not be_valid
    task_joiner.errors.full_messages.should == ['Child task can\'t be blank']
  end
end
