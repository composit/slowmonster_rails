'use strict'

angular.module('slowMonster.controllers', [])
  .controller('tasksCtrl', ['$scope', ($scope) ->
    $scope.tasks = tasks
  ])
