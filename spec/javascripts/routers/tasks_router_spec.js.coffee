describe 'tasks router', ->
  beforeEach ->
    @task = new Slowmonster.Models.Task id: 123
    @router = new Slowmonster.Routers.TasksRouter tasks: [@task]
    @routeSpy = sinon.spy()
    try
      Backbone.history.start silent: true
    catch e

  describe 'initialize', ->
    it 'initializes a task collection', ->
      expect( @router.tasks.models ).toEqual [@task]

  describe 'new', ->
    it 'fires the newTask route', ->
      @router.on 'route:newTask', @routeSpy
      @router.navigate 'new', trigger: true
      expect( @routeSpy ).toHaveBeenCalled()
    it 'renders the new view with the collection', ->
      newTaskViewStub = sinon.stub( Slowmonster.Views.Tasks, 'NewView' ).returns new Backbone.View()
      @router.newTask()
      expect( newTaskViewStub ).toHaveBeenCalledWith collection: @router.tasks
      newTaskViewStub.restore()

  describe 'index', ->
    it 'fires the index route', ->
      @router.on 'route:index', @routeSpy
      @router.navigate 'index', trigger: true
      expect( @routeSpy ).toHaveBeenCalledOnce()

    it 'renders the index view with the collection', ->
      taskIndexViewStub = sinon.stub( Slowmonster.Views.Tasks, 'IndexView' ).returns new Backbone.View()
      @router.index()
      expect( taskIndexViewStub ).toHaveBeenCalledWith tasks: @router.tasks
      taskIndexViewStub.restore()

  describe 'show', ->
    it 'fires the show route', ->
      @router.on 'route:show', @routeSpy
      @router.navigate '123', trigger: true
      expect( @routeSpy ).toHaveBeenCalledWith '123'

    it 'renders the show view with the correct task', ->
      showTaskViewStub = sinon.stub( Slowmonster.Views.Tasks, 'ShowView' ).returns new Backbone.View()
      @router.show '123'
      expect( showTaskViewStub ).toHaveBeenCalledWith model: @task
      showTaskViewStub.restore()

  describe 'edit', ->
    it 'fires the edit route', ->
      @router.on 'route:edit', @routeSpy
      @router.navigate '123/edit', trigger: true
      expect( @routeSpy ).toHaveBeenCalledWith '123'

    it 'renders the edit view with the correct task', ->
      editTaskViewStub = sinon.stub( Slowmonster.Views.Tasks, 'EditView' ).returns new Backbone.View()
      @router.edit '123'
      expect( editTaskViewStub ).toHaveBeenCalledWith model: @task
