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
    @listChildren()
    return this

  listParents: ->
    parentsView = new Slowmonster.Views.TaskParents.IndexView taskParents: @model.get( 'taskParents' ), childTask: @model
    $( @el ).find( '#parents' ).html parentsView.render().el

  listChildren: ->
    if @model.get 'child_task_joiners'
      childrens = @model.get( 'child_task_joiners' ).map ( childViewJoiner ) =>
        Slowmonster.tasks.get childViewJoiner.child_task_id
      childrenTasks = new Slowmonster.Collections.TasksCollection childrens
      childrenView = new Slowmonster.Views.Tasks.IndexView tasks: childrenTasks, parentTask: @model
      $( @el ).append childrenView.render().el
