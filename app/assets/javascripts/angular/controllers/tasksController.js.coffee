'use strict'

angular.module('slowMonster.controllers')
  .controller('tasksCtrl', ['$scope', 'tasks', ($scope, tasks) ->
    $scope.$watch 'currentTaskTime', (newTime, oldTime) ->
      for task in tasks
        if task.id == newTime.task_id
          newTime.taskContent = task.content
  ])
