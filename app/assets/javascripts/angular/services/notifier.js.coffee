'use strict'

angular.module('slowMonster.services')
  .factory('Notifier', ['$window', ($window) ->
    return (message) ->
      if (!($window.Notification))
        alert("This browser does not support desktop notification")
      else if ($window.Notification.permission == "granted")
        notification = new $window.Notification(message)
  ])
