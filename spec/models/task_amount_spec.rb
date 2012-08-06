require 'spec_helper'

describe TaskAmount do
  specify { build( :task_amount ).should be_valid }

  it 'requires a task' do
    task_amount = build :task_amount, task: nil
    task_amount.should_not be_valid
    task_amount.errors.full_messages.should == ['Task can\'t be blank']
  end

  it 'requires an amount' do
    task_amount = build :task_amount, amount: nil
    task_amount.should_not be_valid
    task_amount.errors.full_messages.should == ['Amount can\'t be blank']
  end

  it 'requires an incurred at time' do
    task_amount = build :task_amount, incurred_at: nil
    task_amount.should_not be_valid
    task_amount.errors.full_messages.should == ['Incurred at can\'t be blank']
  end
end
