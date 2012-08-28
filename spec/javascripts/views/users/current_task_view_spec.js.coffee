describe 'user current task view', ->
  describe 'render', ->
    it 'displays the template with the current task content', ->
      task = new Slowmonster.Models.Task id: 123, content: 'test task'
      Slowmonster.tasks = new Slowmonster.Collections.TasksCollection [task]
      task_time = new Slowmonster.Models.TaskTime task_id: 123
      view = new Slowmonster.Views.Users.CurrentTaskView model: task_time
      expect( $( view.render().el ) ).toContain '.content:contains("test task")'
