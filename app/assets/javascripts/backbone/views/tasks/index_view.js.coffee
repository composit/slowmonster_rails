Slowmonster.Views.Tasks ||= {}

class Slowmonster.Views.Tasks.IndexView extends Backbone.View
  template: JST['backbone/templates/tasks/index']

  initialize: ->
    @options.tasks.bind 'reset', @addAll
    @options.tasks.bind 'currentTicketTime:change', @updateCurrent

  addAll: =>
    @options.tasks.each @addOne
    @$( '#tasks' ).sortable
      axis: 'y'
      update: =>
        @reprioritize()

  addOne: ( task ) =>
    view = new Slowmonster.Views.Tasks.TaskView model : task
    @$( '#tasks' ).append view.render().el

  render: =>
    $( @el ).html @template tasks: @options.tasks.toJSON()
    @addAll()
    @updateCurrent()
    return this

  reprioritize: ->
    $.ajax
      url: '/tasks/reprioritize'
      data: @$( '#tasks' ).sortable 'serialize'
      type: 'PUT'

  updateCurrent: =>
    $.ajax
      url: '/users/current_task_time'
      type: 'GET'
    .done ( data ) =>
      currentTaskTime = new Slowmonster.Models.TaskTime data
      currentView = new Slowmonster.Views.Users.CurrentTaskView model: currentTaskTime
      @$( '#current-task-time' ).html currentView.render().el
