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
    exect( subject.reload.multiplier ).to eq 1.23
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
end
