describe Slowmonster.Models.TaskTime, ->
  describe 'instantiation', ->
    it 'exhibits attributes', ->
      taskTime = new Slowmonster.Models.TaskTime
      taskTime.set task_id: 123
      expect( taskTime.get 'task_id' ).toEqual 123

    it 'attaches the task', ->
      task = new Slowmonster.Models.Task id: 123
      Slowmonster.tasks = new Slowmonster.Collections.TasksCollection [task]
      taskTime = new Slowmonster.Models.TaskTime task_id: task.id
      expect( taskTime.get( 'task' ) ).toEqual task
