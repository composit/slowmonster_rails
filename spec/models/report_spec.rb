require 'spec_helper'

describe Report do
  subject { build :report }

  it 'has report tasks' do
    task_one = build :report_task
    task_two = build :report_task
    task_three = build :report_task
    subject.report_tasks << [task_one, task_two, task_three]
    subject.save!
    expect( subject.reload.report_tasks ).to eq [task_one, task_two, task_three]
  end

  it 'has a started_at datetime' do
    subject.started_at = Time.zone.parse( '2001-02-03 04:05:06' )
    subject.save!
    expect( subject.reload.started_at.strftime( '%Y-%m-%d %H:%M:%S' ) ).to eq '2001-02-03 04:05:06'
  end

  it 'has a unit' do
    subject.unit = 'day'
    subject.save!
    expect( subject.reload.unit ).to eq 'day'
  end

  it 'has a duration' do
    subject.duration = 3
    subject.save!
    expect( subject.reload.duration ).to eq 3
  end

  describe "calculated_started_at" do
    it 'returns the started_at datetime if one exists' do
      sometime = 3.days.ago
      subject.started_at = sometime
      expect( subject.calculated_started_at ).to eq sometime
    end

    it 'figures out a started at datetime based on the units and duration if one is not specified' do
      subject.started_at = nil
      subject.unit = 'day'
      subject.duration = '3'
      expect( subject.calculated_started_at ).to be_within( 1.second ).of( 4.days.ago )
    end
  end

  it 'requires a unit' do
    subject.unit = nil
    expect( subject.valid? ).to be_false
    expect( subject.errors.to_a ).to eq ['Unit can\'t be blank']
  end

  it 'requires the unit to be a day, week, month or year' do
    subject.unit = 'else'
    expect( subject.valid? ).to be_false
    expect( subject.errors.to_a ).to eq ['Unit is not included in the list']
    %w(day week month year).each do |unit_value|
      subject.unit = unit_value
      expect( subject.valid? ).to be_true
    end
  end

  it 'requires a duration' do
    subject.duration = nil
    expect( subject.valid? ).to be_false
    expect( subject.errors.to_a ).to eq ['Duration can\'t be blank']
  end

  describe 'dates' do
    it 'returns daily dates'
    it 'returns weekly dates'
    it 'returns monthly dates'
    it 'returns yearly dates'
  end

  describe 'chart_values' do
    let( :report_task_one ) { build :report_task }
    let( :report_task_two ) { build :report_task }
    let( :report_task_three ) { build :report_task }

    before do
      subject.duration = 3
      subject.started_at = Time.zone.parse( '2003-01-02' )

      report_task_one.stub( task_content: 'one' )
      report_task_two.stub( task_content: 'two' )
      report_task_three.stub( task_content: 'three' )

      report_task_one.stub( :totals_over_time ) { [1,2,3] }
      report_task_two.stub( :totals_over_time ) { [4,5,6] }
      report_task_three.stub( :totals_over_time ) { [7,8,9] }
      subject.report_tasks = [report_task_one, report_task_two, report_task_three]
    end

    it 'returns "Date" and the task content as the headers' do
      expect( subject.chart_values.first ).to eq ['Date', 'one', 'two', 'three']
    end

    it 'returns the task chart_values' do
      expect( subject.chart_values[1..3] ).to eq [
        ['January 02, 2003', 1, 4, 7],
        ['January 03, 2003', 2, 5, 8],
        ['January 04, 2003', 3, 6, 9],
      ]
    end
  end
end
