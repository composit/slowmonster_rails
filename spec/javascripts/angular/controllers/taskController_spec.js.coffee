describe 'taskCtrl', ->
  beforeEach(module('slowMonster'))

  TaskTime = null
  $rootScope = null
  $httpBackend = null

  beforeEach inject (_$rootScope_, $controller, _TaskTime_, _$httpBackend_) ->
    TaskTime = _TaskTime_
    $rootScope = _$rootScope_
    @scope = $rootScope.$new()
    @goodTask = {"id": 456, "content": "good task"}
    @scope.tasks = [{"id": 123, "content": "bad task"}, @goodTask]
    $controller('taskCtrl', { $scope: @scope, $routeParams: { taskId: "456" }, TaskTime, $rootScope })

    $httpBackend = _$httpBackend_
    $httpBackend.when('POST', '/task_times?format=json').respond({})

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  it 'sets the task on instantiation', ->
    expect(@scope.task).toEqual(@goodTask)

  describe 'starting a task', ->
    it 'creates the task time', ->
      spyOn(TaskTime, "save")
      @scope.startTask()
      expect(TaskTime.save).toHaveBeenCalledWith({ task_id: 456 }, jasmine.any(Function))

    it 'emits the starting event', ->
      spyOn($rootScope, "$emit")
      @scope.startTask()
      $httpBackend.flush()
      expect($rootScope.$emit).toHaveBeenCalledWith('start task', { task_id: 456 })
