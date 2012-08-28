class Slowmonster.Models.TaskTime extends Backbone.Model
  paramRoot: 'taskTime'

  initialize: ( options ) ->
    super options
    if options && options.task_id
      @set 'task', Slowmonster.tasks.get options.task_id
