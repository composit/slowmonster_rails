describe 'currentTaskTimesListCtrl', ->
  scope = null
  TaskTime = null
  $httpBackend = null

  beforeEach(module('slowMonster'))

  beforeEach inject ($rootScope, $controller, _TaskTime_, _$httpBackend_) ->
    TaskTime = _TaskTime_
    scope = $rootScope.$new()
    scope.tasks = [{id: 123, content: 'other task'}, {id: 456, content: 'good task'}]
    scope.currentTaskTimes = [{id: 789}]
    $controller('currentTaskTimesListCtrl', {$scope: scope})
    $httpBackend = _$httpBackend_
    $httpBackend.when('PUT', '/task_times/789/stop?format=json').respond({})

  afterEach -
    #$httpBackend.verifyNoOutstandingExpectation()
    #$httpBackend.verifyNoOutstandingRequest()

  it 'finds the task content', ->
    expect(scope.taskContent(456)).toEqual('good task')

  describe 'when stopping a task time', ->
    it 'stops a task time', ->
      spyOn(TaskTime, 'stop')
      scope.stopTaskTime(789)
      expect(TaskTime.stop).toHaveBeenCalledWith({taskTimeId: 789}, jasmine.any(Function))

    it 'removes the task time from the list', ->
      scope.stopTaskTime(789)
      $httpBackend.flush()
      expect(scope.currentTaskTimes).toEqual([])
