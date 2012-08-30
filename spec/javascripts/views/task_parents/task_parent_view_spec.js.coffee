describe 'task parent view', ->
  beforeEach ->
    parentTask = new Slowmonster.Models.Task id: 123, content: 'test task'
    Slowmonster.tasks = new Slowmonster.Collections.TasksCollection [parentTask]
    @taskParent = new Slowmonster.Models.TaskParent parent_task_id: 123, multiplier: 7
    @taskParent.collection = new Slowmonster.Collections.TaskParentsCollection [@taskParent]
    @view = new Slowmonster.Views.TaskParents.TaskParentView model: @taskParent
    @$el = $( @view.render().el )

  it 'has a classname of task-parent', ->
    expect( @view.render().el ).toHaveClass 'task-parent'

  describe 'render', ->
    it 'renders the template with the parent task content and multiplier', ->
      expect( @$el ).toContain '.content:contains("test task")'
      expect( @$el ).toContain '.multiplier:contains("*7")'

  describe 'delete', ->
    beforeEach ->
      @server = sinon.fakeServer.create()
      @server.respondWith 'DELETE', '/task_joiners/123', [200, { "Content-Type": "application/json" }, '']

    afterEach ->
      @server.restore()

    it 'fires the delete action when the delete link is clicked', ->
      deleteSpy = sinon.spy Slowmonster.Views.TaskParents.TaskParentView.prototype, 'delete'
      view = new Slowmonster.Views.TaskParents.TaskParentView model: @taskParent
      $( view.render().el ).find( '.delete' ).click()
      expect( deleteSpy ).toHaveBeenCalledOnce()
      deleteSpy.restore()

    it 'calls the server with the delete details', ->
      destroySpy = sinon.spy @view.model, 'destroy'
      @$el.find( '.delete' ).click()
      expect( destroySpy ).toHaveBeenCalledOnce()
      destroySpy.restore()
      
    describe 'success', ->
      it 'removes the task parent from the collection', ->
        removeSpy = sinon.spy @view.model.collection, 'remove'
        @view.delete()
        @server.respond()
        expect( removeSpy ).toHaveBeenCalledWith @view.model
        removeSpy.restore()

      it 'removens the view from the index', ->
        removeSpy = sinon.spy Slowmonster.Views.TaskParents.TaskParentView.prototype, 'remove'
        view = new Slowmonster.Views.TaskParents.TaskParentView model: @taskParent
        view.delete()
        @server.respond()
        expect( removeSpy ).toHaveBeenCalledOnce()
        removeSpy.restore()
