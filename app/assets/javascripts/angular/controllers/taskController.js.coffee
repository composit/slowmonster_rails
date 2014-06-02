'use strict'

angular.module('slowMonster.controllers')
  .controller('taskCtrl', ['$scope', '$routeParams', 'TaskTime', '$rootScope', ($scope, $routeParams, TaskTime, $rootScope) ->
    $scope.setTask = (taskId) ->
      for task in $scope.tasks
        if task.id == parseInt(taskId)
          $scope.task = task

    $scope.setTask($routeParams.taskId)

    $scope.startTask = ->
      TaskTime.save { task_id: $scope.task.id }, (taskTime) ->
        $rootScope.$emit('start task', taskTime)

    $scope.options = {renderer: 'area'}
    $scope.series = [{
      name: 'Series 1',
      color: 'steelblue',
      data: [{x: 0, y: 23}, {x: 1, y: 15}, {x: 2, y: 79}, {x: 3, y: 31}, {x: 4, y: 60}]
    }, {
      name: 'Series 2',
      color: 'lightblue',
      data: [{x: 0, y: 30}, {x: 1, y: 20}, {x: 2, y: 64}, {x: 3, y: 50}, {x: 4, y: 15}]
    }]
  ])
