'use strict'

angular.module('slowMonster.controllers')
  .controller('tasksCtrl', ['$scope', '$rootScope', '$timeout', ($scope, $rootScope, $timeout) ->
    $scope.counter = 0
    $scope.$watch 'currentTaskTime', (newTime, oldTime) ->
      for task in $scope.tasks
        if task.id == newTime.task_id
          newTime.taskContent = task.content
          
    unbind = $rootScope.$on 'start task', ->
      $scope.status = 'worker'
      $scope.counter = 25#*60

      $scope.breakTick = ->
        $scope.counter--
        if($scope.counter == 0)
          $scope.status = 'done'
        else
          breakTimer = $timeout($scope.breakTick, 1000)

      $scope.workerTick = ->
        $scope.counter--
        if($scope.counter == 0)
          $scope.status = 'breaker'
          $scope.counter = 5#*60
          breakTimer = $timeout($scope.breakTick, 1000)
        else
          workTimer = $timeout($scope.workerTick, 1000)

      workTimer = $timeout($scope.workerTick, 1000)

    $scope.$on('$destroy', unbind)
  ])
