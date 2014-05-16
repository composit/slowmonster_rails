'use strict'

angular.module('slowMonster.controllers')
  .controller('tasksCtrl', ['$scope', '$rootScope', ($scope, $rootScope) ->

    unbind = $rootScope.$on 'start task', (event, taskTime) ->
      $scope.currentTaskTimes.push(taskTime)

    $scope.$on('$destroy', unbind)
  ])
