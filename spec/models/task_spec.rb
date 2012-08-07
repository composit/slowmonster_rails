require 'spec_helper'

describe Task do
  specify { build( :task ).should be_valid }

  it 'persists content' do
    task = create :task, content: 'this is a test'
    task.reload.content.should == 'this is a test'
  end

  context 'requires content' do
    let( :task ) { build :task, content: nil }

    specify { task.should_not be_valid }
    specify { task.valid?; task.errors.full_messages.should == ['Content can\'t be blank'] }
  end

  it 'persists a user' do
    user = create :user
    task = create :task, user: user
    task.reload.user.should == user
  end

  it 'requires a user' do
    task = build :task, user: nil
    task.should_not be_valid
    task.errors.full_messages.should == ['User can\'t be blank']
  end

  it 'persists many child tasks' do
    task = create :task
    3.times { task.child_tasks << build( :task ) }
    task.reload.child_tasks.length.should == 3
  end

  it 'persists many parent tasks' do
    task = create :task
    3.times { task.parent_tasks << build( :task ) }
    task.reload.parent_tasks.length.should == 3
  end

  it 'persists many task times' do
    task = create :task
    3.times { task.task_times << build( :task_time ) }
    task.reload.task_times.length.should == 3
  end

  it 'persists many task amounts' do
    task = create :task
    3.times { task.task_amounts << build( :task_amount ) }
    task.reload.task_amounts.length.should == 3
  end

  context 'with ancestors' do
    let( :task ) { create :task, parent_tasks: [parent_task] }
    let( :parent_task ) { create :task, parent_tasks: [grandparent_task] }
    let( :grandparent_task ) { create :task, parent_tasks: [great_grandparent_task] }
    let( :great_grandparent_task ) { create :task }

    specify { task.ancestor_task_ids.should == [parent_task.id, grandparent_task.id, great_grandparent_task.id] }

    it 'does not allow a parent task (recursive) to be set as a child task' do
      task.child_task_joiners.build child_task: grandparent_task
      task.should_not be_valid
      task.errors.full_messages.should == ['A task cannot be both an ancestor and descendant of the same task.']
    end
  end

  context 'with descendants' do
    let( :task ) { create :task, child_tasks: [child_task] }
    let( :child_task ) { create :task, child_tasks: [grandchild_task] }
    let( :grandchild_task ) { create :task, child_tasks: [great_grandchild_task] }
    let( :great_grandchild_task ) { create :task }

    specify { task.descendant_task_ids.should == [child_task.id, grandchild_task.id, great_grandchild_task.id] }

    it 'does not allow a child task (recursive) to be set as a parent task' do
      task.parent_task_joiners.build parent_task: grandchild_task
      task.should_not be_valid
      task.errors.full_messages.should == ['A task cannot be both an ancestor and descendant of the same task.']
    end
  end

  it 'deletes task joiners when it is deleted' do
    task = create :task
    task.parent_tasks << build( :task )
    task.child_tasks << build( :task )
    task.destroy
    TaskJoiner.count.should == 0
  end

  context 'starting' do
    let( :user ) { create :user }
    let( :task ) { create :task, user: user }

    describe 'creates a new task time' do
      before :each do
        task.start
      end

      it 'associated with itself' do
        task.task_times.count.should == 1
      end

      it 'with a started at value of the current time' do
        task.task_times.last.started_at.should be_within( 1 ).of Time.zone.now
      end
    end

    context 'with an open task time' do
      let( :other_task ) { create :task, user: user }
      let!( :open_task_time ) { create :task_time, task: other_task }

      it 'adds an ended at time to any ticket times for the current user without an ended at time' do
        task.start
        open_task_time.reload.ended_at.should_not be_nil
        open_task_time.reload.ended_at.should be_within( 1 ).of Time.zone.now
      end

      it 'does not add an ended at time to ticket times that already have ended at times' do
        open_task_time.update_attributes! ended_at: '2001-02-03 04:05:06'
        task.start
        open_task_time.reload.ended_at.strftime( '%Y-%m-%d %H:%M:%S' ).should == '2001-02-03 04:05:06'
      end

      it 'does not add an ended at time to ticket times for other users' do
        other_task.user = create :user
        other_task.save!
        task.start
        open_task_time.reload.ended_at.should be_nil
      end
    end
  end

  context 'adding amounts' do
    let( :task ) { create :task }

    describe 'creates a new task amount with the current time as the started at time' do
      before :each do
        task.add_amount
      end

      it 'creates a new task amount associated with itself' do
        task.task_amounts.count.should == 1
      end

      it 'sets the incurred at time to the current time' do
        task.task_amounts.last.incurred_at.should be_within( 1 ).of Time.zone.now
      end

      it 'defaults the amount to 1' do
        task.task_amounts.last.amount.should == 1
      end

      it 'allows the overriding of amounts' do
        task.add_amount 123
        task.task_amounts.last.amount.to_i.should == 123
      end
    end
  end
end
