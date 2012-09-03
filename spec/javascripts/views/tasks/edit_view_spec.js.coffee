describe 'task edit view', ->
  beforeEach ->
    @task = new Slowmonster.Models.Task id: 123
    @task.collection = new Slowmonster.Collections.TasksCollection
    @view = new Slowmonster.Views.Tasks.EditView model: @task

  describe 'instantiation', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

  describe 'render', ->
    it 'creates a form', ->
      expect( $( @view.render().el ) ).toContain( 'form#edit-task' )

    it 'lists the parents', ->
      Slowmonster.tasks = new Slowmonster.Collections.TasksCollection []
      taskParents = new Slowmonster.Collections.TaskParentsCollection [{ id: '123' }, { id: '456' }]
      @task.set 'taskParents', taskParents
      parentsViewStub = sinon.stub( Slowmonster.Views.TaskParents, 'IndexView' ).returns new Backbone.View()
      view = new Slowmonster.Views.Tasks.EditView model: @task
      view.render()
      expect( parentsViewStub ).toHaveBeenCalledWith taskParents: taskParents, childTask: @view.model
      parentsViewStub.restore()

    it 'lists the children', ->
      @task.set 'child_task_joiners', [{ child_task_id: 123 }]
      Slowmonster.tasks = new Slowmonster.Collections.TasksCollection []
      childrenViewStub = sinon.stub( Slowmonster.Views.Tasks, 'IndexView' ).returns new Backbone.View()
      view = new Slowmonster.Views.Tasks.EditView model: @task
      view.render()
      expect( childrenViewStub ).toHaveBeenCalled() #TODO called with the child tasks and a parent task
      childrenViewStub.restore()

  describe 'update', ->
    beforeEach ->
      @server = sinon.fakeServer.create()
      @$el = $( @view.render().el )

    afterEach ->
      @server.restore()

    it 'updates on submit', ->
      updateSpy = sinon.spy Slowmonster.Views.Tasks.EditView.prototype, 'update'
      view = new Slowmonster.Views.Tasks.EditView model: @task
      $( view.render().el ).find( 'form' ).submit()
      expect( updateSpy ).toHaveBeenCalledOnce()
      updateSpy.restore()

    it 'posts the model attributes', ->
      saveSpy = sinon.spy @view.model, 'save'
      @$el.find( 'form' ).submit()
      expect( saveSpy ).toHaveBeenCalledOnce()
      saveSpy.restore()

    describe 'success', ->
      beforeEach ->
        @server.respondWith 'PUT', '/tasks/123', [204, { 'Content-Type': 'application/json' }, '' ]
        
      it 'displays the task page', ->
        @$el.find( 'form' ).submit()
        @server.respond()
        expect( window.location.hash ).toEqual "#/123"
