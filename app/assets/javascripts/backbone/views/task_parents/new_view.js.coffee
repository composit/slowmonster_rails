Slowmonster.Views.TaskParents ||= {}

class Slowmonster.Views.TaskParents.NewView extends Backbone.View
  template: JST['backbone/templates/task_parents/new']

  events:
    'submit #new-task-parent': 'save'

  initialize: ( options ) ->
    super options
    @model = new @collection.model()

    @model.bind 'change:errors', =>
      @render()

  save: ( e ) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset 'errors'

    @collection.create @model.toJSON(),
      success: ( taskParent ) =>
        @model = taskParent
        alert 'good job'

      error: ( taskParent, jqXHR ) =>
        @model.set errors: $.parseJSON jqXHR.responseText

  render: ->
    $( @el ).html @template @model.toJSON()
    @$( 'form' ).backboneLink @model
    return this
