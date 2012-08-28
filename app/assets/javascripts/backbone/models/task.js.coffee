class Slowmonster.Models.Task extends Backbone.Model
  paramRoot: 'task'

  defaults:
    content: null

  initialize: ( options ) ->
    super( options )
    if options
      @set 'taskParents', new Slowmonster.Collections.TaskParentsCollection options.parent_task_joiners

class Slowmonster.Collections.TasksCollection extends Backbone.Collection
  model: Slowmonster.Models.Task
  url: '/tasks'
