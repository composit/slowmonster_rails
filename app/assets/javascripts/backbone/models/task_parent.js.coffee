class Slowmonster.Models.TaskParent extends Backbone.Model
  paramRoot: 'taskParent'

  initialize: ( options ) ->
    super options
    if options && options.parent_task_id
      @set 'parentTask', Slowmonster.tasks.get options.parent_task_id

class Slowmonster.Collections.TaskParentsCollection extends Backbone.Collection
  model: Slowmonster.Models.TaskParent
  url: '/task_joiners'
