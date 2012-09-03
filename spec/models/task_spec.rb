require 'spec_helper'

describe Task do
  specify { expect( build( :task ) ).to be_valid }

  it 'persists content' do
    task = create :task, content: 'this is a test'
    expect( task.reload.content ).to eq 'this is a test'
  end

  context 'requires content' do
    let( :task ) { build :task, content: nil }

    specify { expect( task ).to_not be_valid }
    specify { task.valid?; expect( task.errors.full_messages ).to eq ['Content can\'t be blank'] }
  end

  it 'persists a user' do
    user = create :user
    task = create :task, user: user
    expect( task.reload.user ).to eq user
  end

  it 'requires a user' do
    task = build :task, user: nil
    expect( task ).to_not be_valid
    expect( task.errors.full_messages ).to eq ['User can\'t be blank']
  end

  it 'persists many child tasks' do
    task = create :task
    3.times { task.child_tasks << build( :task ) }
    expect( task.reload.child_tasks.length ).to eq 3
  end

  it 'persists many parent tasks' do
    task = create :task
    3.times { task.parent_tasks << build( :task ) }
    expect( task.reload.parent_tasks.length ).to eq 3
  end

  it 'persists many task times' do
    task = create :task
    3.times { task.task_times << build( :task_time ) }
    expect( task.reload.task_times.length ).to eq 3
  end

  it 'persists many task amounts' do
    task = create :task
    3.times { task.task_amounts << build( :task_amount ) }
    expect( task.reload.task_amounts.length ).to eq 3
  end

  it 'persists a priority' do
    task = create :task, priority: 123
    expect( task.reload.priority ).to eq 123
  end

  it 'includes parent task joiners in the json' do
    task = create :task
    expect( task.to_json ).to match /"parent_task_joiners":/ 
  end

  it 'includes child task joiners in the json' do
    task = create :task
    expect( task.to_json ).to match /"child_task_joiners":/ 
  end

  it 'sorts by priority' do
    task_2 = create :task, priority: 2
    task_1 = create :task, priority: 1
    task_3 = create :task, priority: 3
    expect( Task.prioritized ).to eq [task_1, task_2, task_3]
  end

  context 'with ancestors' do
    let( :task ) { create :task, parent_tasks: [parent_task] }
    let( :parent_task ) { create :task, parent_tasks: [grandparent_task] }
    let( :grandparent_task ) { create :task, parent_tasks: [great_grandparent_task] }
    let( :great_grandparent_task ) { create :task }

    specify { expect( task.ancestor_task_ids ).to eq [parent_task.id, grandparent_task.id, great_grandparent_task.id] }

    it 'does not allow a parent task (recursive) to be set as a child task' do
      task.child_task_joiners.build child_task_id: grandparent_task.id
      expect( task ).to_not be_valid
      expect( task.errors.full_messages ).to eq ['A task cannot be both an ancestor and descendant of the same task.']
    end
  end

  context 'with descendants' do
    let( :task ) { create :task, child_tasks: [child_task] }
    let( :child_task ) { create :task, child_tasks: [grandchild_task] }
    let( :grandchild_task ) { create :task, child_tasks: [great_grandchild_task] }
    let( :great_grandchild_task ) { create :task }

    specify { expect( task.descendant_task_ids ).to eq [child_task.id, grandchild_task.id, great_grandchild_task.id] }

    it 'does not allow a child task (recursive) to be set as a parent task' do
      task.parent_task_joiners.build parent_task_id: grandchild_task.id
      expect( task ).to_not be_valid
      expect( task.errors.full_messages ).to eq ['A task cannot be both an ancestor and descendant of the same task.']
    end
  end

  it 'deletes task joiners when it is deleted' do
    task = create :task
    task.parent_tasks << build( :task )
    task.child_tasks << build( :task )
    task.destroy
    expect( TaskJoiner.count ).to eq 0
  end

  context 'starting' do
    let( :user ) { create :user }
    let( :task ) { create :task, user: user }

    describe 'creates a new task time' do
      before :each do
        task.start
      end

      it 'associated with itself' do
        expect( task.task_times.count ).to eq 1
      end

      it 'with a started at value of the current time' do
        expect( task.task_times.last.started_at ).to be_within( 1 ).of Time.zone.now
      end
    end

    context 'with an open task time' do
      let( :other_task ) { create :task, user: user }
      let!( :open_task_time ) { create :task_time, task: other_task }

      it 'adds an ended at time to any ticket times for the current user without an ended at time' do
        task.start
        expect( open_task_time.reload.ended_at ).to_not be_nil
        expect( open_task_time.reload.ended_at ).to be_within( 1 ).of Time.zone.now
      end

      it 'does not add an ended at time to ticket times that already have ended at times' do
        open_task_time.update_attributes! ended_at: '2001-02-03 04:05:06'
        task.start
        expect( open_task_time.reload.ended_at.strftime '%Y-%m-%d %H:%M:%S' ).to eq '2001-02-03 04:05:06'
      end

      it 'does not add an ended at time to ticket times for other users' do
        other_task.user = create :user
        other_task.save!
        task.start
        expect( open_task_time.reload.ended_at ).to be_nil
      end
    end
  end

  context 'closing' do
    let( :user ) { create :user }
    let( :task ) { create :task, user: user }

    it 'sets the closed at datetime' do
      task.close
      expect( task.reload.closed_at ).to be_within( 1 ).of Time.zone.now
    end
  end

  context 'adding amounts' do
    let( :task ) { create :task }

    describe 'creates a new task amount with the current time as the started at time' do
      before :each do
        task.add_amount
      end

      it 'creates a new task amount associated with itself' do
        expect( task.task_amounts.count ).to eq 1
      end

      it 'sets the incurred at time to the current time' do
        expect( task.task_amounts.last.incurred_at ).to be_within( 1 ).of Time.zone.now
      end

      it 'defaults the amount to 1' do
        expect( task.task_amounts.last.amount ).to eq 1
      end

      it 'allows the overriding of amounts' do
        task.add_amount 123
        expect( task.task_amounts.last.amount.to_i ).to eq 123
      end
    end
  end

  it 'returns open tasks' do
    create_list :task, 3, closed_at: nil
    create_list :task, 2, closed_at: Time.zone.now
    expect( Task.open.length ).to eq 3
  end

  context 'totals' do
    context 'directly associated task times' do
      before :each do
        Timecop.freeze( 0 )
      end

      after :each do
        Timecop.return
      end

      it 'returns values with decimals' do
        3.times { subject.task_times << mock_model( TaskTime, started_at: 4200.seconds.ago, ended_at: Time.zone.now ) }
        expect( subject.total_value ).to eq 3.5
      end

      it 'returns values within a range' do
        task = create :task
        task.task_times << create( :task_time, started_at: 3.hours.ago, ended_at: 2.hours.ago )
        task.task_times << create( :task_time, started_at: 2.hours.ago, ended_at: 1.hour.ago )
        task.task_times << create( :task_time, started_at: 1.hour.ago, ended_at: Time.zone.now )
        expect( task.total_value( 2.hours.ago, 1.hour.ago ) ).to eq 1
      end

      it 'splits task times that lie partially within the range' do
        task = create :task
        task.task_times << create( :task_time, started_at: 3.hours.ago, ended_at: Time.zone.now )
        expect( task.total_value( 2.hours.ago, 1.hour.ago ) ).to eq 1
      end

      context 'incomplete task times' do
        let( :task ) { create :task }

        before :each do
          task.task_times << create( :task_time, started_at: 3.hours.ago, ended_at: nil )
        end

        it 'sets the end_time to the current time if none exists' do
          expect( task.total_value ).to eq 3
        end

        it 'still honors thresholds' do
          expect( task.total_value( 2.hours.ago, 1.hour.ago ) ).to eq 1
        end
      end
    end

    context 'child tasks' do
      it 'returns the child task values' do
        yesterday, today = double( :yesterday ), double( :today )
        task_joiner = mock_model TaskJoiner
        task_joiner.stub( :total_child_value ).with( yesterday, today ) { 123.4 }
        subject.child_task_joiners << task_joiner
        expect( subject.total_value( yesterday, today ) ).to eq 123.4
      end
    end
  end
end
