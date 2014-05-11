describe 'tasksListCtrl', ->
  beforeEach(module('slowMonster'))

  beforeEach inject ($rootScope, $controller) ->
    scope = $rootScope.$new()
    $controller('tasksListCtrl', { $scope: scope })
