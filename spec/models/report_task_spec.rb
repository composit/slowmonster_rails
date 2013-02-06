require 'spec_helper'

describe ReportTask do
  subject { build :report_task }

  it 'belongs to a task' do
    task = create :task
    subject.task = task
    subject.save!
    expect( subject.reload.task ).to eq task
  end

  it 'belongs to a report' do
    report = create :report
    subject.report = report
    subject.save!
    expect( subject.reload.report ).to eq report
  end

  it 'has a multiplier' do
    subject.multiplier = 1.23
    subject.save!
    expect( subject.reload.multiplier ).to eq 1.23
  end

  it 'requires a task' do
    subject.task = nil
    expect( subject.valid? ).to be_false
    expect( subject.errors.to_a ).to eq ['Task can\'t be blank']
  end

  it 'requires a report' do
    subject.report = nil
    expect( subject.valid? ).to be_false
    expect( subject.errors.to_a ).to eq ['Report can\'t be blank']
  end

  it 'has a default multiplier of 1.0' do
    expect( ReportTask.new.multiplier ).to eq 1.0
  end
  
  it 'determines task content' do
    task = build( :task, content: 'test task' )
    subject.task = task
    expect( subject.task_content ).to eq 'test task'
  end

  context 'totals over time' do
    let( :task ) { create :task }

    it 'returns daily results' do
      report = build( :report, started_at: '2012-09-01', unit: 'day', duration: 4 )
      task.task_times << create( :task_time, started_at: Time.zone.parse( '2012-09-01 01:00' ), ended_at: Time.zone.parse( '2012-09-01 03:00' ) )
      task.task_times << create( :task_time, started_at: Time.zone.parse( '2012-09-01 05:00' ), ended_at: Time.zone.parse( '2012-09-01 07:00' ) )
      task.task_times << create( :task_time, started_at: Time.zone.parse( '2012-09-02 01:00' ), ended_at: Time.zone.parse( '2012-09-02 03:00' ) )
      task.task_times << create( :task_time, started_at: Time.zone.parse( '2012-09-04 01:00' ), ended_at: Time.zone.parse( '2012-09-04 03:00' ) )
      subject.report = report
      subject.task = task
      expect( subject.totals_over_time ).to eq [4.0, 2.0, 0.0, 2.0]
    end

    it 'returns weekly results'
    it 'returns monthly results'
    it 'returns yearly results'
  end
end
