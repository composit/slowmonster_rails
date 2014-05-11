'use strict'

angular.module('slowMonster.controllers')
  .controller('taskCtrl', ['$scope', '$routeParams', 'Task', '$rootScope', ($scope, $routeParams, Task, $rootScope) ->
    $scope.setTask = (taskId) ->
      for task in $scope.tasks
        if task.id == parseInt(taskId)
          $scope.task = task

    $scope.setTask($routeParams.taskId)

    $scope.startTask = ->
      $rootScope.$emit('start task')
      Task.start({ taskId: $scope.task.id }, $scope.task)
  ])
