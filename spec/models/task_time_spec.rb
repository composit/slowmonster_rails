require 'spec_helper'

describe TaskTime do
  specify { expect(build :task_time).to be_valid }

  it 'requires a task' do
    task_time = build :task_time, task: nil
    expect(task_time).to_not be_valid
    expect(task_time.errors.full_messages).to eq ['Task can\'t be blank']
  end

  it 'requires a started at time' do
    task_time = build :task_time, started_at: nil
    expect(task_time).to_not be_valid
    expect(task_time.errors.full_messages).to eq ['Started at can\'t be blank']
  end

  it 'returns current task times' do
    time_1 = create :task_time, ended_at: 1.day.ago
    time_2 = create :task_time, ended_at: nil
    time_3 = create :task_time, ended_at: 2.days.ago
    time_4 = create :task_time, ended_at: nil
    expect(TaskTime.current).to eq [time_2, time_4]
  end

  it 'stops' do
    task_time = build :task_time, ended_at: nil
    task_time.stop
    expect(task_time.ended_at).to be_within(1.second).of(Time.zone.now)
  end

  describe 'determining seconds left' do
    it 'determines how many go seconds are left' do
      task = build(:task)
      task_time = build(:task_time, started_at: 500.seconds.ago)
      expect(task_time.go_seconds).to eq(1000)
      expect(task_time.break_seconds).to eq(300)
    end

    it 'determines how many break seconds are left' do
      task = build(:task)
      task_time = build(:task_time, started_at: 1700.seconds.ago)
      expect(task_time.go_seconds).to eq(0)
      expect(task_time.break_seconds).to eq(100)
    end
  end

  describe 'as json' do
    before do
      @task_time = build(:task_time)
    end

    it 'includes go seconds' do
      expect(@task_time.to_json).to match /"go_seconds":/ 
    end

    it 'includes break seconds' do
      expect(@task_time.to_json).to match /"break_seconds":/ 
    end
  end
end
