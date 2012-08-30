Slowmonster.Views.TaskParents ||= {}

class Slowmonster.Views.TaskParents.TaskParentView extends Backbone.View
  template: JST['backbone/templates/task_parents/task_parent']

  className: 'task-parent'

  events:
    'click .delete': 'delete'

  render: ->
    $( @el ).html @template @model.toJSON()
    if @model.get 'parentTask'
      $( @el ).find( '.content' ).html @model.get( 'parentTask' ).get 'content'
    $( @el ).find( '.multiplier' ).html "*#{@model.get 'multiplier'}"
    return this

  delete: =>
    if confirm 'Are you sure you want to delete this association?'
      @model.destroy
        success: =>
          @remove()
    return false
