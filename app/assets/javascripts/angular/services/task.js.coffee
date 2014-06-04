'use strict'

angular.module('slowMonster.services')
  .factory('Task', ['$resource', ($resource) ->
    return $resource '/tasks/:taskId', {format: 'json'}
  ])
