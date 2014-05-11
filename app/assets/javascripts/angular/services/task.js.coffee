'use strict'

angular.module('slowMonster.services')
  .factory('Task', ['$resource', ($resource) ->
    return $resource '/tasks/:taskId', null,
      {
        'start': { method: 'PUT', url: '/tasks/:taskId/start/' }
      }
  ])
