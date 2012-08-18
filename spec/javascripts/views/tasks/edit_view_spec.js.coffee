describe 'task edit view', ->
  beforeEach ->
    task = new Slowmonster.Models.Task id: 123, content: 'test'
    @view = new Slowmonster.Views.Tasks.EditView model: task

  describe 'instantiation', ->
    it 'creates a div element', ->
      expect( @view.el.nodeName ).toEqual 'DIV'

  describe 'render', ->
    it 'creates a form', ->
      expect( $( @view.render().el ) ).toContain( 'form#edit-task' )
