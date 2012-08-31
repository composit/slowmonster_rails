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
end
