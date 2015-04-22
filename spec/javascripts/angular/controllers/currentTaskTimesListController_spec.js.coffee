describe 'currentTaskTimesListCtrl', ->
  scope = null

  beforeEach(module('slowMonster'))

  beforeEach inject ($rootScope, $controller) ->
    scope = $rootScope.$new()
    scope.currentTaskTimes = [{id: 789}]
    $controller('currentTaskTimesListCtrl', {$scope: scope})

  it 'removes the task time from the list', ->
    scope.removeTaskTime(789)
    expect(scope.currentTaskTimes).toEqual([])
