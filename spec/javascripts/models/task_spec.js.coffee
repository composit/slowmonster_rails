describe Slowmonster.Models.Task, ->
  describe 'when instantiated', ->
    beforeEach ->
      @task = new Slowmonster.Models.Task

    it 'exhibits attributes', ->
      @task.set content: 'test content'
      expect( @task.get 'content' ).toEqual 'test content'

describe Slowmonster.Collections.TasksCollection, ->
  beforeEach ->
    @tasks = new Slowmonster.Collections.TasksCollection

  it 'contains tasks', ->
    expect( @tasks.model ).toEqual Slowmonster.Models.Task

  it 'has the url of "/tasks"', ->
    expect( @tasks.url ).toEqual '/tasks'
