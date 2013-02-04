require 'spec_helper'

describe TaskJoiner do
  subject { build( :task_joiner ) }

  specify { expect( subject ).to be_valid }

  it 'persists a parent task' do
    parent_task = create :task
    subject.parent_task = parent_task
    subject.save!
    expect( subject.reload.parent_task ).to eq parent_task
  end

  it 'persists a child task' do
    child_task = create :task
    subject.child_task = child_task
    subject.save!
    expect( subject.reload.child_task ).to eq child_task
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
