'use strict'

angular.module('slowMonster.controllers')
  .controller('currentTaskTimeCtrl', ['$scope', 'TaskTime', '$timeout', 'Notifier', ($scope, TaskTime, $timeout, Notifier) ->

    $scope.assignTask = ->
      for task in $scope.tasks
        if task.id == $scope.taskTime.task_id
          $scope.task = task
          $scope.counter = task.go_seconds

    $scope.stopTaskTime = ->
      taskTimeId = $scope.taskTime.id
      TaskTime.stop {taskTimeId: taskTimeId}, ->
        $scope.stopped = true
        $timeout.cancel($scope.workTimer)
        $timeout.cancel($scope.breakTimer)

    $scope.startTaskTime = ->
      $scope.counter = $scope.taskTime.go_seconds
      $scope.workTimer = $timeout($scope.workerTick, 1000)
      $scope.breakTimer = null
      $scope.breaktime = false
      $scope.stopped = false

    $scope.restartTask = ->
      TaskTime.save { task_id: $scope.task.id }, (taskTime) ->
        $scope.taskTime = taskTime
        $scope.startTaskTime()

    $scope.breakTick = ->
      $scope.counter--
      Notifier("break's over. do some stuff!") if($scope.counter == 0)
      if($scope.counter <= 0)
        $scope.stopTaskTime()
      else
        $scope.breakTimer = $timeout($scope.breakTick, 1000)

    $scope.workerTick = ->
      $scope.counter--
      Notifier("take a break!") if($scope.counter == 0)
      if($scope.counter <= 0)
        $scope.break()
      else
        $scope.workTimer = $timeout($scope.workerTick, 1000)

    $scope.break = ->
      TaskTime.break {taskTimeId: $scope.taskTime.id}, ->
        $scope.breaktime = true
        $scope.counter = $scope.taskTime.break_seconds
        $timeout.cancel($scope.breakTimer)
        $scope.breakTimer = $timeout($scope.breakTick, 1000)

    $scope.assignTask()
    $scope.startTaskTime()
  ])
