'use strict'

angular.module('slowMonster.controllers')
  .controller('currentTaskTimesListCtrl', ['$scope', 'TaskTime', ($scope, TaskTime) ->
    $scope.removeTaskTime = (taskTimeId) ->
      for taskTime in $scope.currentTaskTimes
        if(taskTime.id == taskTimeId)
          indexToRemove = $scope.currentTaskTimes.indexOf(taskTime)
      if(indexToRemove > -1)
        $scope.currentTaskTimes.splice(indexToRemove, 1)
  ])
