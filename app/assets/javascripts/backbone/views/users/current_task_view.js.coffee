Slowmonster.Views.Users ||= {}

class Slowmonster.Views.Users.CurrentTaskView extends Backbone.View
  template: JST["backbone/templates/users/current_task"]

  render: =>
    $( @el ).html @template @model.toJSON()
    return this
