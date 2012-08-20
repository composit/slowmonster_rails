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
