describe 'tasksCtrl', ->
  beforeEach(module('slowMonster'))

  scope = null
  tasksCtrl = null

  beforeEach inject ($rootScope, $controller) ->
    scope = $rootScope.$new()
    tasks = [{"id": 123, "content": "bad task"}, {"id": 456, "content": "good task"}]
    tasksCtrl = $controller('tasksCtrl', { $scope: scope, tasks: tasks })

  it 'determines the current task content', ->
    scope.currentTaskTime = {"task_id": 456}
    scope.$digest()
    expect(scope.currentTaskTime.taskContent).toEqual("good task")
