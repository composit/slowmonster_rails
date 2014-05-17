'use strict'

angular.module('slowMonster.controllers')
  .controller('currentTaskTimeCtrl', ['$scope', 'TaskTime', '$timeout', 'Notifier', ($scope, TaskTime, $timeout, Notifier) ->

    $scope.taskContent = () ->
      for task in $scope.tasks
        if task.id == $scope.taskTime.task_id
          return task.content

    $scope.stopTaskTime = () ->
      taskTimeId = $scope.taskTime.id
      TaskTime.stop {taskTimeId: taskTimeId}, ->
        $scope.removeTaskTime(taskTimeId)

    $scope.counter = 25*60

    $scope.breakTick = ->
      $scope.counter--
      if($scope.counter == 0)
        Notifier("break's over. do some stuff!")
        $scope.stopTaskTime()
      else
        breakTimer = $timeout($scope.breakTick, 1000)

    $scope.workerTick = ->
      $scope.counter--
      if($scope.counter == 0)
        Notifier("take a break!")
        $scope.breaktime = true
        $scope.counter = 5*60
        breakTimer = $timeout($scope.breakTick, 1000)
      else
        workTimer = $timeout($scope.workerTick, 1000)

    workTimer = $timeout($scope.workerTick, 1000)
  ])
