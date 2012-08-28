Slowmonster.Views.TaskParents ||= {}

class Slowmonster.Views.TaskParents.IndexView extends Backbone.View
  template: JST['backbone/templates/task_parents/index']

  initialize: ->
    @options.taskParents.bind 'reset', @addAll

  addAll: =>
    @options.taskParents.each @addOne

  addOne: ( taskParent ) =>
    view = new Slowmonster.Views.TaskParents.TaskParentView model: taskParent
    @$( '#task-parents' ).append view.render().el

  render: =>
    $( @el ).html @template taskParents: @options.taskParents.toJSON
    @addAll()
    return this
