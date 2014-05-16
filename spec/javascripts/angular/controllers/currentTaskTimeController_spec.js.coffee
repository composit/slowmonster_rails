describe 'currentTaskTimeCtrl', ->
  scope = null
  TaskTime = null
  $httpBackend = null

  beforeEach(module('slowMonster'))

  beforeEach inject ($rootScope, $controller, _TaskTime_, _$httpBackend_) ->
    TaskTime = _TaskTime_
    scope = $rootScope.$new()
    scope.taskTime = {id: 789, task_id: 345}
    scope.removeTaskTime = ->
    $controller('currentTaskTimeCtrl', {$scope: scope})
    $httpBackend = _$httpBackend_
    $httpBackend.when('PUT', '/task_times/789/stop?format=json').respond({})

  afterEach ->
    #$httpBackend.verifyNoOutstandingExpectation()
    #$httpBackend.verifyNoOutstandingRequest()

  it 'finds the task content', ->
    scope.tasks = [{id: 456, content: 'other task'}, {id: 345, content: 'good task'}]
    expect(scope.taskContent()).toEqual('good task')

  describe 'when stopping a task time', ->
    it 'stops a task time', ->
      spyOn(TaskTime, 'stop')
      scope.stopTaskTime()
      expect(TaskTime.stop).toHaveBeenCalledWith({taskTimeId: 789}, jasmine.any(Function))

    it 'removes the task time from the list', ->
      spyOn(scope, 'removeTaskTime')
      scope.stopTaskTime()
      $httpBackend.flush()
      expect(scope.removeTaskTime).toHaveBeenCalledWith(789)

  it 'starts a timer', ->
    expect(scope.counter).toEqual(25*60)

  xit 'starts a break timer when the "work timer" finishes'

  xit 'stops the task when the break timer finishes'
