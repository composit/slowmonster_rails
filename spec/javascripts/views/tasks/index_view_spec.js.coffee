describe 'task index view', ->
  beforeEach ->
    @task = new Slowmonster.Models.Task id: 123
    @tasks = new Slowmonster.Collections.TasksCollection [@task]
    @view = new Slowmonster.Views.Tasks.IndexView tasks: @tasks

  it 'calls addAll when the tasks are reset', ->
    addAllSpy = sinon.spy Slowmonster.Views.Tasks.IndexView.prototype, 'addAll'
    view = new Slowmonster.Views.Tasks.IndexView tasks: @tasks
    @tasks.trigger 'reset'
    expect( addAllSpy ).toHaveBeenCalled()
    addAllSpy.restore()

  it 'calls updateCurrent when the current ticket time changes', ->
    updateSpy = sinon.spy Slowmonster.Views.Tasks.IndexView.prototype, 'updateCurrent'
    view = new Slowmonster.Views.Tasks.IndexView tasks: @tasks
    @tasks.trigger 'currentTicketTime:change'
    expect( updateSpy ).toHaveBeenCalled()
    updateSpy.restore()
  
  describe 'addAll', ->
    it 'calls addOne for each task', ->
      addOneSpy = sinon.spy Slowmonster.Views.Tasks.IndexView.prototype, 'addOne'
      view = new Slowmonster.Views.Tasks.IndexView tasks: @tasks
      view.addAll()
      expect( addOneSpy ).toHaveBeenCalled()
      addOneSpy.restore()

    xit 'makes the tasks sortable', ->

    describe 'sortable', ->
      xit 'calls reprioritize when tasks are reordered'

  describe 'addOne', ->
    it 'creates a new task view', ->
      taskViewStub = sinon.stub( Slowmonster.Views.Tasks, 'TaskView' ).returns new Backbone.View()
      @view.addOne( @task )
      expect( taskViewStub ).toHaveBeenCalledWith model: @task
      taskViewStub.restore()

  describe 'render', ->
    it 'calls addAll', ->
      addAllSpy = sinon.spy Slowmonster.Views.Tasks.IndexView.prototype, 'addAll'
      view = new Slowmonster.Views.Tasks.IndexView tasks: @tasks
      view.render()
      expect( addAllSpy ).toHaveBeenCalledOnce()
      addAllSpy.restore()

    it 'calls updateCurrent', ->
      updateCurrentSpy = sinon.spy Slowmonster.Views.Tasks.IndexView.prototype, 'updateCurrent'
      view = new Slowmonster.Views.Tasks.IndexView tasks: @tasks
      view.render()
      expect( updateCurrentSpy ).toHaveBeenCalledOnce()
      updateCurrentSpy.restore()

  describe 'reprioritize', ->
    xit 'sends the new order to the server', ->
      server = sinon.fakeServer.create()
      callback = sinon.spy jQuery, 'ajax'
      @view.reprioritize()
      expect( callback ).toHaveBeenCalledWith( 'priority data' )
      server.restore()


  describe 'updateCurrent', ->
    beforeEach ->
      @server = sinon.fakeServer.create()
      @server.respondWith 'GET', '/users/current_task_time', [200, { 'Content-Type': 'application/json' }, '{"task_name": "Test Task"}']
      @taskTimeStub = sinon.stub( Slowmonster.Models, 'TaskTime' ).returns new Backbone.Model()

    afterEach ->
      @server.restore()
      @taskTimeStub.restore()

    it 'creates a new TaskTime object with data from the server', ->
      @view.updateCurrent()
      @server.respond()
      expect( @taskTimeStub ).toHaveBeenCalledWith task_name: 'Test Task'

    xit 'updates the view', ->
      currentTaskViewStub = sinon.stub( Slowmonster.Views.Users, 'CurrentTaskView' ).returns new Backbone.View()
      @view.updateCurrent()
      @server.respond()
      # how to tell if it was called with the right object?
      expect( currentTaskViewStub ).toHaveBeenCalledOnce()
      currentTaskViewStub.restore()
