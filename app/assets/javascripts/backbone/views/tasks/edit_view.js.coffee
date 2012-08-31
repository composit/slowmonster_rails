Slowmonster.Views.Tasks ||= {}

class Slowmonster.Views.Tasks.EditView extends Backbone.View
  template: JST["backbone/templates/tasks/edit"]

  events:
    "submit #edit-task" : "update"

  update: ( e ) ->
    e.preventDefault()
    e.stopPropagation()

    @model.save null,
      success: ( task ) =>
        @model = task
        window.location.hash = "/#{@model.id}"

  render: ->
    $( @el ).html @template @model.toJSON()
    this.$( 'form' ).backboneLink @model
    @listParents()
    return this

  listParents: ->
    parentsView = new Slowmonster.Views.TaskParents.IndexView taskParents: @model.get( 'taskParents' ), childTask: @model
    $( @el ).find( '#parents' ).html parentsView.render().el
