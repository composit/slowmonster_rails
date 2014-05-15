describe 'tasksCtrl', ->
  beforeEach(module('slowMonster'))

  scope = null
  $rootScope = null

  beforeEach inject (_$rootScope_, $controller) ->
    $rootScope = _$rootScope_
    scope = $rootScope.$new()
    scope.tasks = [{"id": 123, "content": "other task"}, {"id": 456, "content": "good task"}]
    $controller('tasksCtrl', {$scope: scope})

  describe 'when a "start task" event is fired', ->
    it 'starts a timer', ->
      $rootScope.$emit('start task', {task_id: 123})
      expect(scope.counter).toEqual(25*60)

    xit 'starts a break timer when the "work timer" finishes'

