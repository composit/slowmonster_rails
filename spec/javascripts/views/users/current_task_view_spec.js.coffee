describe 'user current task view', ->
  describe 'render', ->
    it 'displays the template', ->
      task_time = new Slowmonster.Models.TaskTime task_content: 'test task'
      view = new Slowmonster.Views.Users.CurrentTaskView model: task_time
      expect( $( view.render().el ) ).toContain '.content:contains("test task")'
