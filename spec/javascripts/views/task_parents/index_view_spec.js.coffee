describe 'task parent index view', ->
  beforeEach ->
    @taskParent = new Slowmonster.Models.TaskParent id: 123
    @taskParents = new Slowmonster.Collections.TaskParentsCollection [@taskParent]
    @view = new Slowmonster.Views.TaskParents.IndexView taskParents: @taskParents

  it 'calls addAll when the taskParents are reset', ->
    addAllSpy = sinon.spy Slowmonster.Views.TaskParents.IndexView.prototype, 'addAll'
    view = new Slowmonster.Views.TaskParents.IndexView taskParents: @taskParents
    @taskParents.trigger 'reset'
    expect( addAllSpy ).toHaveBeenCalled()
    addAllSpy.restore()

  describe 'addAll', ->
    it 'calls addOne for each taskParent', ->
      addOneSpy = sinon.spy Slowmonster.Views.TaskParents.IndexView.prototype, 'addOne'
      view = new Slowmonster.Views.TaskParents.IndexView taskParents: @taskParents
      view.addAll()
      expect( addOneSpy ).toHaveBeenCalled()
      addOneSpy.restore()

  describe 'addOne', ->
    it 'creates a new taskParent view', ->
      taskParentViewStub = sinon.stub( Slowmonster.Views.TaskParents, 'TaskParentView' ).returns new Backbone.View()
      @view.addOne( @taskParent )
      expect( taskParentViewStub ).toHaveBeenCalledWith model: @taskParent
      taskParentViewStub.restore()

  describe 'render', ->
    it 'calls addAll', ->
      addAllSpy = sinon.spy Slowmonster.Views.TaskParents.IndexView.prototype, 'addAll'
      view = new Slowmonster.Views.TaskParents.IndexView taskParents: @taskParents
      view.render()
      expect( addAllSpy ).toHaveBeenCalledOnce()
      addAllSpy.restore()
