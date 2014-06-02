'use strict'

angular.module('slowMonster', [
  'ngRoute',
  'ngResource',
  'slowMonster.controllers',
  'slowMonster.directives',
  'slowMonster.services'
]).
config(['$routeProvider', '$resourceProvider', ($routeProvider, $resourceProvider) ->
  $routeProvider.when('/', { templateUrl: 'assets/angular/partials/tasksList.html', controller: 'tasksListCtrl' })
  $routeProvider.when('/:taskId', { templateUrl: 'assets/angular/partials/task.html', controller: 'taskCtrl' })
  $routeProvider.otherwise({ redirectTo: '/' })
])

angular.module('slowMonster.controllers', [])
angular.module('slowMonster.directives', [])
angular.module('slowMonster.services', [])
