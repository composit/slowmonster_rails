Slowmonster.Views.Tasks ||= {}

class Slowmonster.Views.Tasks.TaskView extends Backbone.View
  template: JST["backbone/templates/tasks/task"]
  className: ['task']

  events:
    'click .editor': 'edit'
    'click .starter': 'start'
    'click .closer': 'close'
    'click .adder': 'addAmount'

  destroy: () ->
    if confirm 'are you sure you want to delete this task?'
      @model.destroy()
      this.remove()

    return false

  render: ->
    $( @el ).html @template @model.toJSON()
    $( @el ).attr 'id', "tasks_#{@model.id}"
    @model.get( 'taskParents' ).each ( taskParent ) =>
      $( @el ).find( '.parent-tasks' ).append "<span>#{taskParent.get( 'parentTask' ).get 'content'}</span>"

    return this

  start: ->
    $.ajax
      url: "/tasks/#{@model.id}/start"
      type: 'PUT'
    .done =>
      @model.collection.trigger 'currentTicketTime:change'

  edit: ->
    window.location.hash = "#{@model.id}/edit"

  close: ->
    if confirm 'are you sure you want to close this task?'
      $.ajax
        url: "/tasks/#{@model.id}/close"
        type: 'PUT'
      .done =>
        @model.collection.remove @model

  addAmount: ->
    $.ajax
      url: "/tasks/#{@model.id}/add_amount"
      type: 'PUT'
      data: { amount: $(@el).find('.amount').val() }
    .done =>
      $(@el).find('.amount').val('')