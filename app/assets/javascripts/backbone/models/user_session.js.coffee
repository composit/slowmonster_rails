class Slowmonster.Models.UserSession extends Backbone.Model
  paramRoot: 'user_session'
  urlRoot: '/user_sessions'

  defaults:
    username: null
    password: null
    remember_me: null
    errors: []
