describe 'tasksCtrl', ->
  describe 'instantiation' ->
    testScope = $rootScope.$new()
    tasks = [1,2,3]
    ctrl = $controller('tasksCtrl', {
      $scope: testScope
    })
    expect(testScope.tasks).toBe([1,2,3])

