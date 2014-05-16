describe 'tasksCtrl', ->
  beforeEach(module('slowMonster'))

  scope = null
  $rootScope = null

  beforeEach inject (_$rootScope_, $controller) ->
    $rootScope = _$rootScope_
    scope = $rootScope.$new()
    scope.tasks = [{"id": 123, "content": "other task"}, {"id": 456, "content": "good task"}]
    scope.currentTaskTimes = []
    $controller('tasksCtrl', {$scope: scope})

  describe 'when a "start task" event is fired', ->
    it 'adds the taskTime to the current task times', ->
      $rootScope.$emit('start task', {task_id: 123})
      expect(scope.currentTaskTimes).toEqual([{task_id: 123}])
