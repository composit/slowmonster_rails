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
    @updateCurrent()
    return this

  reprioritize: ->
    $.ajax
      url: '/tasks/reprioritize'
      data: @$( '#tasks' ).sortable 'serialize'
      type: 'PUT'

  updateCurrent: ->
    $.ajax
      url: '/users/current_task'
      type: 'GET'
    .done ( data ) =>
      currentTask = new Slowmonster.Models.TaskTime( data )
      currentView = new Slowmonster.Views.Users.CurrentTaskView model: currentTask
      @$( "#current-task" ).html( currentView.render().el )
