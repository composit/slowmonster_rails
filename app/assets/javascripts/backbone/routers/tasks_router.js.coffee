class Slowmonster.Routers.TasksRouter extends Backbone.Router
  initialize: (options) ->
    @tasks = new Slowmonster.Collections.TasksCollection()
    @tasks.reset options.tasks

  routes:
    "new"      : "newTask"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newTask: ->
    @view = new Slowmonster.Views.Tasks.NewView(collection: @tasks)
    $("#new-task").html(@view.render().el)

  index: ->
    @view = new Slowmonster.Views.Tasks.IndexView(tasks: @tasks)
    $("#tasks").html(@view.render().el)
    @userView = new Slowmonster.Views.Users.ShowView( user: @user )
    $("#user").html(@userView.render().el)

  show: (id) ->
    task = @tasks.get(id)

    @view = new Slowmonster.Views.Tasks.ShowView(model: task)
    $("#tasks").html(@view.render().el)

  edit: (id) ->
    task = @tasks.get(id)

    @view = new Slowmonster.Views.Tasks.EditView(model: task)
    $("#tasks").html(@view.render().el)
