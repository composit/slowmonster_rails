'use strict'

angular.module('slowMonster.controllers')
  .controller('taskCtrl', ['$scope', '$routeParams', 'TaskTime', '$rootScope', ($scope, $routeParams, TaskTime, $rootScope) ->
    $scope.setTask = (taskId) ->
      for task in $scope.tasks
        if task.id == parseInt(taskId)
          $scope.task = task

    $scope.setTask($routeParams.taskId)

    $scope.startTask = ->
      TaskTime.save { task_id: $scope.task.id }, ->
        $rootScope.$emit('start task', { task_id: $scope.task.id })
  ])
