'use strict'

angular.module('slowMonster.controllers')
  .controller('taskCtrl', ['$scope', '$routeParams', 'tasks', ($scope, $routeParams, tasks) ->
    $scope.setTask = (taskId) ->
      for task in tasks
        $scope.task = task if task.id == taskId

    $scope.setTask($routeParams.taskId)
  ])
