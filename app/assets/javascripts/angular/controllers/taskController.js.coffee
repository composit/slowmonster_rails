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
      name: '4 week ave',
      color: '#1D79A0',
      data: [{x: 0, y: $scope.task.chart_numbers[0]}, {x: 2, y: $scope.task.chart_numbers[1]}, {x: 3, y: $scope.task.chart_numbers[2]}, {x: 4, y: $scope.task.chart_numbers[3]}]
    }, {
      name: 'Rolling ave',
      color: '#5697A2',
      data: [{x: 0, y: $scope.task.chart_numbers[0]}, {x: 2, y: $scope.task.chart_numbers[1]}, {x: 3, y: $scope.task.chart_numbers[2]}, {x: 4, y: $scope.task.chart_numbers[3]}]
    }]
  ])
