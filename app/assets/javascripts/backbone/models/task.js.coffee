class Slowmonster.Models.Task extends Backbone.Model
  paramRoot: 'task'

  defaults:
    content: null

class Slowmonster.Collections.TasksCollection extends Backbone.Collection
  model: Slowmonster.Models.Task
  url: '/tasks'
