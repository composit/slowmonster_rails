class Slowmonster.Routers.UserSessionsRouter extends Backbone.Router
  initialize: (options) ->

  routes:
    "login" : "newUserSession"

  newUserSession: ->
    @view = new Slowmonster.Views.UserSessions.NewView()
    $( '#user-session' ).html( @view.render().el )
