require 'spec_helper'

describe TaskJoiner do
  specify { expect( build :task_joiner ).to be_valid }

  it 'requires a parent task' do
    task_joiner = build :task_joiner, parent_task: nil
    expect( task_joiner ).to_not be_valid
    expect( task_joiner.errors.full_messages ).to eq ['Parent task can\'t be blank']
  end

  it 'requires a child task' do
    task_joiner = build :task_joiner, child_task: nil
    expect( task_joiner ).to_not be_valid
    expect( task_joiner.errors.full_messages ).to eq ['Child task can\'t be blank']
  end

  it 'returns a total child value, multiplied' do
    yesterday, today = double( :yesterday ), double( :today )
    child_task = mock_model Task
    child_task.stub( :total_value ).with( yesterday, today ) { 111.11 }
    subject.child_task = child_task
    subject.multiplier = 3
    expect( subject.total_child_value( yesterday, today ) ).to eq 333.33
  end
end
