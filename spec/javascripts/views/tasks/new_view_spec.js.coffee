describe 'task new view', ->
  beforeEach ->
    @tasks = new Slowmonster.Collections.TasksCollection
    @view = new Slowmonster.Views.Tasks.NewView collection: @tasks

  describe 'instantiation', ->
    xit 'builds a new task object in the collection'
    xit 're-renders when errors change'

  describe 'save', ->
    xit 'saves on submit'
    xit 'removes old errors'
    xit 'posts the model attributes'

    describe 'success', ->
      xit 'renders the index page'

    describe 'error', ->
      xit 'sets the error on the model'

  describe 'render', ->
    xit 'links the form to the view'
