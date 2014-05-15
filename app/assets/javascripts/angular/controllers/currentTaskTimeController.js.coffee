'use strict'

angular.module('slowMonster.controllers')
  .controller('currentTaskTimeCtrl', ['$scope', 'TaskTime', ($scope, TaskTime) ->

    $scope.taskContent = () ->
      for task in $scope.tasks
        if task.id == $scope.taskTime.task_id
          return task.content

    $scope.stopTaskTime = () ->
      taskTimeId = $scope.taskTime.id
      TaskTime.stop {taskTimeId: taskTimeId}, ->
        $scope.removeTaskTime(taskTimeId)
  ])
