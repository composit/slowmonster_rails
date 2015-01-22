require 'spec_helper'

describe TaskAmount do
  specify { expect( build :task_amount ).to be_valid }

  it 'requires a task' do
    task_amount = build :task_amount, task: nil
    expect( task_amount ).to_not be_valid
    expect( task_amount.errors.full_messages ).to eq ['Task can\'t be blank']
  end

  it 'requires an amount' do
    task_amount = build :task_amount, amount: nil
    expect( task_amount ).to_not be_valid
    expect( task_amount.errors.full_messages ).to eq ['Amount can\'t be blank']
  end

  it 'requires an incurred at time' do
    task_amount = build :task_amount, incurred_at: nil
    expect( task_amount ).to_not be_valid
    expect( task_amount.errors.full_messages ).to eq ['Incurred at can\'t be blank']
  end
end
