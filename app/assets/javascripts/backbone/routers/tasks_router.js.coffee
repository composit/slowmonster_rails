class Slowmonster.Routers.TasksRouter extends Backbone.Router
  initialize: (options) ->
    Slowmonster.tasks = new Slowmonster.Collections.TasksCollection()
    Slowmonster.tasks.reset options.tasks
    @tasks = Slowmonster.tasks

  routes:
    "new"      : "newTask"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"       : "index"

  newTask: ->
    @view = new Slowmonster.Views.Tasks.NewView collection: @tasks
    $("#new-task-block").html @view.render().el

  index: ->
    @view = new Slowmonster.Views.Tasks.IndexView tasks: @tasks
    $("#tasks").html @view.render().el

  show: (id) ->
    task = @tasks.get id

    @view = new Slowmonster.Views.Tasks.ShowView model: task
    $("#tasks").html @view.render().el

  edit: (id) ->
    task = @tasks.get id

    @view = new Slowmonster.Views.Tasks.EditView model: task
    $("#tasks").html @view.render().el
