class Slowmonster.Models.TaskParent extends Backbone.Model
  paramRoot: 'task_joiner'

  defaults:
    multiplier: 1

  initialize: ( options ) ->
    super options
    Slowmonster.tasks.on 'reset', @loadParent
    @loadParent()

  loadParent: =>
    if @get 'parent_task_id'
      @set 'parentTask', Slowmonster.tasks.get @get 'parent_task_id'

class Slowmonster.Collections.TaskParentsCollection extends Backbone.Collection
  model: Slowmonster.Models.TaskParent
  url: '/task_joiners'
