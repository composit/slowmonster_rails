'use strict'

angular.module('slowMonster.controllers')
  .controller('tasksCtrl', ['$scope', '$rootScope', '$window', ($scope, $rootScope, $window) ->

    $scope.notificationPermissionGranted = $window.Notification and $window.Notification.permission == "granted"

    unbind = $rootScope.$on 'start task', (event, taskTime) ->
      $scope.currentTaskTimes.push(taskTime)

    $scope.$on('$destroy', unbind)

    $scope.grantNotificationPermission = ->
      $window.Notification.requestPermission (permission) ->

        if(!('permission' in $window.Notification))
          $window.Notification.permission = permission

        if (permission == "granted")
          $scope.notificationPermissionGranted = true

  ])
