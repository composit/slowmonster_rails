require 'spec_helper'

describe TaskTime do
  specify { expect( build :task_time ).to be_valid }

  it 'requires a task' do
    task_time = build :task_time, task: nil
    expect( task_time ).to_not be_valid
    expect( task_time.errors.full_messages ).to eq ['Task can\'t be blank']
  end

  it 'requires a started at time' do
    task_time = build :task_time, started_at: nil
    expect( task_time ).to_not be_valid
    expect( task_time.errors.full_messages ).to eq ['Started at can\'t be blank']
  end

  it 'returns current task times' do
    time_1 = create :task_time, ended_at: 1.day.ago
    time_2 = create :task_time, ended_at: nil
    time_3 = create :task_time, ended_at: 2.days.ago
    time_4 = create :task_time, ended_at: nil
    expect( TaskTime.current ).to eq [time_2, time_4]
  end
end
