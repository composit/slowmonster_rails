Slowmonster.Views.TaskParents ||= {}

class Slowmonster.Views.TaskParents.IndexView extends Backbone.View
  template: JST['backbone/templates/task_parents/index']

  events:
    'click #new-parent-link': 'newParent'

  initialize: ->
    @options.taskParents.bind 'reset', @addAll
    @options.taskParents.bind 'change', @render

  addAll: =>
    @options.taskParents.each @addOne

  addOne: ( taskParent ) =>
    view = new Slowmonster.Views.TaskParents.TaskParentView model: taskParent
    @$( '#task-parents' ).append view.render().el

  render: =>
    $( @el ).html @template taskParents: @options.taskParents.toJSON
    @addAll()
    return this

  newParent: =>
    newParentView = new Slowmonster.Views.TaskParents.NewView collection: @options.taskParents, childTask: @options.childTask
    $( @el ).find( '#new-task-parent-block' ).html newParentView.render().el
