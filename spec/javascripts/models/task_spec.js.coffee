describe Slowmonster.Models.Task, ->
  describe 'when instantiated', ->
    beforeEach ->
      @task = new Slowmonster.Models.Task()

    it 'exhibits attributes', ->
      @task.set content: 'test content'
      expect( @task.get 'content' ).toEqual 'test content'

    it 'builds a collection of task parents', ->
      taskParentsSpy = sinon.spy Slowmonster.Collections, 'TaskParentsCollection'
      task = new Slowmonster.Models.Task parent_task_joiners: [{ id: '456'}, { id: '789' }]
      expect( taskParentsSpy ).toHaveBeenCalledWith [{ id: '456'}, { id: '789' }]
      taskParentsSpy.restore()

describe Slowmonster.Collections.TasksCollection, ->
  beforeEach ->
    @tasks = new Slowmonster.Collections.TasksCollection

  it 'contains tasks', ->
    expect( @tasks.model ).toEqual Slowmonster.Models.Task

  it 'has the url of "/tasks"', ->
    expect( @tasks.url ).toEqual '/tasks'
