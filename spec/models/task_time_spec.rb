require 'spec_helper'

describe TaskTime do
  specify { build( :task_time ).should be_valid }

  it 'requires a task' do
    task_time = build :task_time, task: nil
    task_time.should_not be_valid
    task_time.errors.full_messages.should == ['Task can\'t be blank']
  end

  it 'requires a started at time' do
    task_time = build :task_time, started_at: nil
    task_time.should_not be_valid
    task_time.errors.full_messages.should == ['Started at can\'t be blank']
  end
end
