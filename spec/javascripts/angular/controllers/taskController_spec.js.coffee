describe 'taskCtrl', ->
  beforeEach(module('slowMonster'))

  Task = null
  $rootScope = null

  beforeEach inject (_$rootScope_, $controller, _Task_) ->
    Task = _Task_
    $rootScope = _$rootScope_
    @scope = $rootScope.$new()
    @goodTask = {"id": 456, "content": "good task"}
    @scope.tasks = [{"id": 123, "content": "bad task"}, @goodTask]
    $controller('taskCtrl', { $scope: @scope, $routeParams: { taskId: "456" }, Task, $rootScope })

  it 'sets the task on instantiation', ->
    expect(@scope.task).toEqual(@goodTask)

  describe 'starting a task', ->
    it 'starts the task service', ->
      spyOn(Task, "start")
      @scope.startTask()
      expect(Task.start).toHaveBeenCalledWith({ taskId: 456 }, @goodTask)

    it 'emits the starting event', ->
      spyOn($rootScope, "$emit")
      @scope.startTask()
      expect($rootScope.$emit).toHaveBeenCalledWith('start task')
