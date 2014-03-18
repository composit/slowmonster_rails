describe 'task view', ->
  describe 'render', ->
    xit 'renders the template'
    it 'displays the task parents', ->
      parentTask = new Slowmonster.Models.Task id: 123, content: 'parent task'
      Slowmonster.tasks = new Slowmonster.Collections.TasksCollection [parentTask]
      task = new Slowmonster.Models.Task parent_task_joiners: [{ parent_task_id: 123 }]
      task.collection = Slowmonster.tasks
      view = new Slowmonster.Views.Tasks.TaskView model: task
      expect( $( view.render().el ) ).toContain 'span.parent-tasks:contains("parent task")'

    xit 'adds the model id to the div id'

  describe 'edit', ->
    beforeEach ->
      @editSpy = sinon.spy Slowmonster.Views.Tasks.TaskView.prototype, 'edit'
      @task = new Slowmonster.Models.Task id: 123
      @view = new Slowmonster.Views.Tasks.TaskView model: @task

    afterEach ->
      @editSpy.restore()

    it 'is fired when the user clicks the edit link', ->
      $el = $( @view.render().el )
      $el.find( '.editor' ).click()
      expect( @editSpy ).toHaveBeenCalled()

    it 'redirects to the edit page', ->
      @view.edit()
      expect( window.location.hash ).toEqual '#123/edit'

  describe 'start', ->
    xit 'calls the server to start the task'

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

  describe 'close', ->
    beforeEach ->
      @server = sinon.fakeServer.create()
      @server.respondWith 'PUT', '/tasks/123/close', [200, { 'Content-Type': 'application/json' }, '']
      sinon.stub( window, 'confirm' ).returns true
      @task = new Slowmonster.Models.Task id: 123
      @task.collection = new Slowmonster.Collections.TasksCollection [@task]
      @view = new Slowmonster.Views.Tasks.TaskView model: @task

    afterEach ->
      window.confirm.restore()
      @server.restore()

    it 'is triggered by a user clicking the close link', ->
      closeSpy = sinon.spy Slowmonster.Views.Tasks.TaskView.prototype, 'close'
      view = new Slowmonster.Views.Tasks.TaskView model: @task
      $( view.render().el ).find( '.closer' ).click()
      expect( closeSpy ).toHaveBeenCalled()#Once()
      closeSpy.restore()

    it 'calls the server', ->
      callback = sinon.spy jQuery, 'ajax'
      @view.close()
      expect( callback ).toHaveBeenCalledWith url: '/tasks/123/close', type: 'PUT'
      callback.restore()

    it 'removes the model from the collection', ->
      removeSpy = sinon.spy @task.collection, 'remove'
      @view.close()
      @server.respond()
      expect( removeSpy ).toHaveBeenCalled()#With @task
      removeSpy.restore()

  describe 'addAmount', ->
    xit 'is triggered by a user clicking the add amount link'
    xit 'calls the server with the specified amount'