'use strict'

angular.module('slowMonster.services')
  .factory('Task', ['$resource', ($resource) ->
    return $resource '/tasks/:taskId', {format: 'json'},
      {addAmount: {method: 'PUT', url: '/tasks/:taskId/add_amount', params: {taskId: "@taskId", amount: "@amount"}}}
  ])
