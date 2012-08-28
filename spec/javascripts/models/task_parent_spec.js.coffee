describe Slowmonster.Models.TaskParent, ->
  describe 'instantiation', ->
    beforeEach ->
      @loadParentSpy = sinon.spy Slowmonster.Models.TaskParent.prototype, 'loadParent'
      @parentTask = new Slowmonster.Models.Task id: 123
      Slowmonster.tasks = new Slowmonster.Collections.TasksCollection [@parentTask]
      @taskParent = new Slowmonster.Models.TaskParent parent_task_id: @parentTask.id

    afterEach ->
      @loadParentSpy.restore()

    it 'exhibits attributes', ->
      @taskParent.set multiplier: '123'
      expect( @taskParent.get 'multiplier' ).toEqual '123'

    it 'attaches the the parent task', ->
      expect( @taskParent.get( 'parentTask' ) ).toEqual @parentTask

    it 'loads the parent when the global tasks reset', ->
      Slowmonster.tasks.trigger 'reset'
      expect( @loadParentSpy ).toHaveBeenCalled()

describe Slowmonster.Collections.TaskParentsCollection, ->
  beforeEach ->
    @taskParents = new Slowmonster.Collections.TaskParentsCollection

  it 'contains task parents', ->
    expect( @taskParents.model ).toEqual Slowmonster.Models.TaskParent

  it 'has the url of "/task_joiners"', ->
    expect( @taskParents.url ).toEqual '/task_joiners'
