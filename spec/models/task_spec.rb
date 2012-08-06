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
end
