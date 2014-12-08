'use strict'

angular.module('slowMonster.controllers')
  .controller('taskCtrl', ['$scope', '$routeParams', 'TaskTime', 'Task', '$rootScope', ($scope, $routeParams, TaskTime, Task, $rootScope) ->
    $scope.setTask = (taskId) ->
      for task in $scope.tasks
        if task.id == parseInt(taskId)
          $scope.task = task

    $scope.setTask($routeParams.taskId)

    $scope.weekFourAve = '-'
    $scope.weekThreeAve = '-'
    $scope.weekTwoAve = '-'
    $scope.weekOneAve = '-'
    $scope.totalToday = '-'

    $scope.startTask = ->
      TaskTime.save { task_id: $scope.task.id }, (taskTime) ->
        $rootScope.$emit('start task', taskTime)

    $scope.options = {
      renderer: 'area',
      height: 100,
      width: 800
    }

    $scope.series = [{data: []}]

    $scope.$watch(
      ( ->
        return $scope.visibleTaskId
      ),
      (newValue, oldValue) ->
        if(newValue == $scope.task.id)
          $scope.getChartNumbers()
    )

    $scope.getChartNumbers = ->
      Task.get {taskId: $scope.task.id}, (response) ->
        numbers = response.task.chart_numbers
        $scope.weekFourAve = numbers[0]
        $scope.weekThreeAve = numbers[1]
        $scope.weekTwoAve = numbers[2]
        $scope.weekOneAve = numbers[3]
        $scope.totalToday = numbers[4]
        $scope.series = [{
          color: '#1D79A0',
          data: [{x: 0, y: numbers[0]}, {x: 14, y: numbers[1]}, {x: 21, y: numbers[2]}, {x: 27, y: numbers[3]}]
        }, {
          color: '#5697A2',
          data: [{x: 0, y: numbers[0]}, {x: 14, y: numbers[1]}, {x: 21, y: numbers[2]}, {x: 27, y: numbers[3]}]
        }]
  ])
