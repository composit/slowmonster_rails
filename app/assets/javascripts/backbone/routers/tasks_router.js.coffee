class Slowmonster.Routers.TasksRouter extends Backbone.Router
  initialize: (options) ->
    Slowmonster.tasks = new Slowmonster.Collections.TasksCollection()
    Slowmonster.tasks.reset options.tasks

  routes:
    "new"      : "newTask"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"       : "index"

  newTask: ->
    @view = new Slowmonster.Views.Tasks.NewView collection: Slowmonster.tasks
    $("#new-task-block").html @view.render().el

  index: ->
    @view = new Slowmonster.Views.Tasks.IndexView tasks: Slowmonster.tasks
    $("#container").html @view.render().el

  show: (id) ->
    task = Slowmonster.tasks.get id

    @view = new Slowmonster.Views.Tasks.ShowView model: task
    $("#container").html @view.render().el

  edit: (id) ->
    task = Slowmonster.tasks.get id

    @view = new Slowmonster.Views.Tasks.EditView model: task
    $("#container").html @view.render().el
