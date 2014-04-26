describe 'taskCtrl', ->
  beforeEach(module('slowMonster'))

  scope = null
  taskCtrl = null

  beforeEach inject ($rootScope, $controller) ->
    scope = $rootScope.$new()
    tasks = [{"id": 123, "content": "bad task"}, {"id": 456, "content": "good task"}]
    taskCtrl = $controller('taskCtrl', { $scope: scope, taskId: 456, tasks: tasks })

  it 'sets the task', ->
    expect(scope.task.content).toEqual('good task')
