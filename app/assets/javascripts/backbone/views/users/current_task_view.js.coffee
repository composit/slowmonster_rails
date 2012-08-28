Slowmonster.Views.Users ||= {}

class Slowmonster.Views.Users.CurrentTaskView extends Backbone.View
  template: JST["backbone/templates/users/current_task"]
  classNames: ['content']

  render: =>
    $( @el ).html @template @model.toJSON()
    $( @el ).find( '.content' ).html @model.get( 'task' ).get 'content'
    return this
