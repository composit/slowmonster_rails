Slowmonster.Views.Tasks ||= {}

class Slowmonster.Views.Tasks.IndexView extends Backbone.View
  template: JST["backbone/templates/tasks/index"]

  initialize: () ->
    @options.tasks.bind('reset', @addAll)

  addAll: () =>
    @options.tasks.each(@addOne)
    @$( '#tasks' ).sortable
      axis: 'y'
      update: =>
        @reprioritize()

  addOne: (task) =>
    view = new Slowmonster.Views.Tasks.TaskView({model : task})
    @$("#tasks").append(view.render().el)

  render: =>
    $(@el).html(@template(tasks: @options.tasks.toJSON() ))
    @addAll()
    return this

  reprioritize: ->
    $.ajax
      url: '/tasks/reprioritize'
      data: @$( '#tasks' ).sortable 'serialize'
      type: 'PUT'
