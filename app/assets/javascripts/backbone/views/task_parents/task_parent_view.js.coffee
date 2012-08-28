Slowmonster.Views.TaskParents ||= {}

class Slowmonster.Views.TaskParents.TaskParentView extends Backbone.View
  template: JST['backbone/templates/task_parents/task_parent']

  render: ->
    $( @el ).html @template @model.toJSON()
    if @model.get 'parentTask'
      $( @el ).find( '.content' ).html @model.get( 'parentTask' ).get 'content'
    return this
