describe 'tasksCtrl', ->
  beforeEach(module('slowMonster'))

  scope = null
  $rootScope = null
  $window = null

  beforeEach inject (_$rootScope_, $controller, _$window_) ->
    $rootScope = _$rootScope_
    $window = _$window_
    scope = $rootScope.$new()
    scope.tasks = [{"id": 123, "content": "other task"}, {"id": 456, "content": "good task"}]
    scope.currentTaskTimes = []
    $controller('tasksCtrl', {$scope: scope, $rootScope, $window})

  describe 'when a "start task" event is fired', ->
    it 'adds the taskTime to the current task times', ->
      $rootScope.$emit('start task', {task_id: 123})
      expect(scope.currentTaskTimes).toEqual([{task_id: 123}])

  xit 'requests permission to display desktop notifications'
