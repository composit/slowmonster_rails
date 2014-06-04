describe 'currentTaskTimeCtrl', ->
  scope = null
  TaskTime = null
  $httpBackend = null

  beforeEach(module('slowMonster'))

  beforeEach inject ($rootScope, $controller, _TaskTime_, _$httpBackend_) ->
    TaskTime = _TaskTime_
    scope = $rootScope.$new()
    scope.tasks = [{id: 456, content: 'other task'}, {id: 345, content: 'good task'}]
    scope.taskTime = {id: 789, task_id: 345, go_seconds: 123}
    scope.removeTaskTime = ->
    $controller('currentTaskTimeCtrl', {$scope: scope})
    $httpBackend = _$httpBackend_
    $httpBackend.when('PUT', '/task_times/789/stop?format=json').respond({})

  afterEach ->
    #$httpBackend.verifyNoOutstandingExpectation()
    #$httpBackend.verifyNoOutstandingRequest()

  it 'assigns the task', ->
    expect(scope.task.content).toEqual('good task')

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

    xit 'stops the timers'

  describe 'when instantiated', ->
    it 'starts a timer', ->
      expect(scope.counter).toEqual(123)

  describe 'when the work timer finishes', ->
    xit 'starts a break timer'
    xit 'sets breaktime to true'
    xit 'sends a notification'

  describe 'when the break timer finishes', ->
    xit 'stops the task time'
    xit 'sends a notification'
