describe 'task parent view', ->
  describe 'render', ->
    it 'renders the template with the parent task content', ->
      parentTask = new Slowmonster.Models.Task id: 123, content: 'test task'
      Slowmonster.tasks = new Slowmonster.Collections.TasksCollection [parentTask]
      taskParent = new Slowmonster.Models.TaskParent parent_task_id: 123
      view = new Slowmonster.Views.TaskParents.TaskParentView model: taskParent
      expect( $( view.render().el ) ).toContain '.content:contains("test task")'
