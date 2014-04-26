'use strict'

angular.module('slowMonster', [
  'ngRoute',
  'slowMonster.controllers',
  'slowMonster.services'
]).
config(['$routeProvider', ($routeProvider) ->
  $routeProvider.when('/', { templateUrl: 'assets/angular/partials/tasks.html', controller: 'tasksCtrl' })
  $routeProvider.when('/:taskId', { templateUrl: 'assets/angular/partials/task.html', controller: 'taskCtrl' })
  $routeProvider.otherwise({ redirectTo: '/' })
])

angular.module('slowMonster.controllers', [])
angular.module('slowMonster.services', [])
