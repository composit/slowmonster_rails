'use strict'

angular.module('slowMonster.services')
  .factory('TaskTime', ['$resource', ($resource) ->
    return $resource '/task_times/:taskTimeId', {format: 'json'},
      {stop: {method: 'PUT', url: '/task_times/:taskTimeId/stop/', params: {taskTimeId: "@taskTimeId"}}}
  ])
