class TaskAssociationValidator < ActiveModel::Validator
  def validate( record )
    #include the ids of the unsaved associated records
    pending_descendant_ids = ( record.descendant_task_ids + record.child_task_joiners.collect( &:child_task_id ) ).uniq
    pending_ancestor_ids = ( record.ancestor_task_ids + record.parent_task_joiners.collect( &:parent_task_id ) ).uniq

    #check out the intersection
    if ( pending_descendant_ids & pending_ancestor_ids ).length > 0
      record.errors[:base] << 'A task cannot be both an ancestor and descendant of the same task.'
    end
  end
end
