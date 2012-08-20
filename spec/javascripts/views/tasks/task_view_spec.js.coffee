describe 'task view', ->
  describe 'render', ->
    xit 'renders the template'
    xit 'adds the model id to the div id'

  describe 'destroy', ->
    xit 'is fired when the user clicks the destroy link'
    xit 'calls the server to destroy the model'
    xit 'removes the model from the view'

  describe 'start', ->
    it 'calls the server to start the task'

    it 'triggers the reset event on its collection', ->
      server = sinon.fakeServer.create()
      server.respondWith 'PUT', '/tasks/123/start', [200, { 'Content-Type': 'application/json' }, '']
      task = new Slowmonster.Models.Task id: 123
      tasks = new Slowmonster.Collections.TasksCollection [task]
      view = new Slowmonster.Views.Tasks.TaskView model: task
      changeSpy = sinon.spy tasks, 'trigger'
      view.start()
      server.respond()
      expect( changeSpy ).toHaveBeenCalledWith 'currentTicketTime:change'


