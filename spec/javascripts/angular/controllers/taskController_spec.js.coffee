describe 'taskCtrl', ->
  beforeEach(module('slowMonster'))

  Task = null
  TaskTime = null
  $rootScope = null
  $httpBackend = null

  beforeEach inject (_$rootScope_, $controller, _Task_, _TaskTime_, _$httpBackend_) ->
    Task = _Task_
    TaskTime = _TaskTime_
    $rootScope = _$rootScope_
    @scope = $rootScope.$new()
    @goodTask = {"id": 456, "content": "good task"}
    @scope.tasks = [{"id": 123, "content": "bad task"}, @goodTask]
    $controller('taskCtrl', { $scope: @scope, $routeParams: { taskId: "456" }, Task, TaskTime, $rootScope })

    $httpBackend = _$httpBackend_
    $httpBackend.when('POST', '/task_times?format=json').respond({})
    $httpBackend.when('GET', '/tasks/456?format=json').respond({task: {chart_numbers: [1,2,3,4]}})
    $httpBackend.when('PUT', '/tasks/456/add_amount?amount=1&format=json').respond({total_today: 789})

  afterEach ->
    $httpBackend.verifyNoOutstandingExpectation()
    $httpBackend.verifyNoOutstandingRequest()

  it 'sets the task on instantiation', ->
    expect(@scope.task).toEqual(@goodTask)

  describe 'starting a task', ->
    it 'creates the task time', ->
      spyOn(TaskTime, "save")
      @scope.startTask()
      expect(TaskTime.save).toHaveBeenCalledWith({task_id: 456}, jasmine.any(Function))

    it 'emits the starting event', ->
      spyOn($rootScope, "$emit")
      @scope.startTask()
      $httpBackend.flush()
      expect($rootScope.$emit).toHaveBeenCalledWith('start task', jasmine.any(Object))

  describe 'adding an amount', ->
    it 'adds an amount to the task', ->
      spyOn(Task, 'addAmount')
      @scope.amountToAdd = '789'
      @scope.addAmount()
      expect(Task.addAmount).toHaveBeenCalledWith({taskId: 456, amount: '789'}, jasmine.any(Function))

    it 'updates the totalToday value', ->
      @scope.addAmount()
      $httpBackend.flush()
      expect(@scope.totalToday).toEqual(789)

  describe 'when becoming visible', ->
    it 'gets the chart numbers', ->
      spyOn(Task, "get")
      @scope.visibleTaskId = @goodTask.id
      @scope.$digest()
      expect(Task.get).toHaveBeenCalledWith({taskId: @goodTask.id}, jasmine.any(Function))

    it 'sets the series', ->
      @scope.getChartNumbers()
      $httpBackend.flush()
      expect(@scope.series[0].data).toEqual([{x: 0, y: 1}, {x: 14, y: 2}, {x: 21, y: 3}, {x: 27, y: 4}])

    it 'sets the week four ave', ->
      @scope.getChartNumbers()
      $httpBackend.flush()
      expect(@scope.weekFourAve).toEqual(1)
