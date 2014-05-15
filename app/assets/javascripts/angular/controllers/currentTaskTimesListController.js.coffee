'use strict'

angular.module('slowMonster.controllers')
  .controller('currentTaskTimesListCtrl', ['$scope', 'TaskTime', ($scope, TaskTime) ->
    $scope.taskContent = (taskId) ->
      for task in $scope.tasks
        if task.id == taskId
          return task.content

    $scope.stopTaskTime = (taskTimeId) ->
      TaskTime.stop {taskTimeId: taskTimeId}, ->
        removeTaskTime(taskTimeId)

    removeTaskTime = (taskTimeId) ->
      for taskTime in $scope.currentTaskTimes
        if(taskTime.id == taskTimeId)
          indexToRemove = $scope.currentTaskTimes.indexOf(taskTime)
      if(indexToRemove > -1)
        $scope.currentTaskTimes.splice(indexToRemove, 1)
  ])
