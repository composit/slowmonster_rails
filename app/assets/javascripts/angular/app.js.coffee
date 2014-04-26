'use strict'

angular.module('slowMonster', [
  'ngRoute',
  'slowMonster.controllers'
]).
config(['$routeProvider', ($routeProvider) ->
  $routeProvider.when('/', { templateUrl: 'assets/angular/partials/tasks.html', controller: 'tasksCtrl' })
  $routeProvider.otherwise({ redirectTo: '/' })
])
