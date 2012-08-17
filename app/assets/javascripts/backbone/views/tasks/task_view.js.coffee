Slowmonster.Views.Tasks ||= {}

class Slowmonster.Views.Tasks.TaskView extends Backbone.View
  template: JST["backbone/templates/tasks/task"]
  className: ['task']

  events:
    "click .destroy" : "destroy"
    'click .starter' : 'start'

  destroy: () ->
    @model.destroy()
    this.remove()

    return false

  render: ->
    $(@el).html @template @model.toJSON()
    $( @el ).attr 'id', "tasks_#{@model.id}"
    return this

  start: ->
    $.ajax
      url: "/tasks/#{@model.id}/start"
      type: 'PUT'
