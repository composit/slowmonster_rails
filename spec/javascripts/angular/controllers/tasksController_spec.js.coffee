describe 'tasksCtrl', ->
  beforeEach(module('slowMonster'))

  scope = null

  beforeEach inject ($rootScope, $controller) ->
    scope = $rootScope.$new()
    scope.tasks = [{"id": 123, "content": "bad task"}, {"id": 456, "content": "good task"}]
    $controller('tasksCtrl', { $scope: scope })

  it 'determines the current task content', ->
    scope.currentTaskTime = {"task_id": 456}
    scope.$digest()
    expect(scope.currentTaskTime.taskContent).toEqual("good task")
