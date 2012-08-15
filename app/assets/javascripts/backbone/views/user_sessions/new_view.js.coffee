Slowmonster.Views.UserSessions ||= {}

class Slowmonster.Views.UserSessions.NewView extends Backbone.View
  template: JST["backbone/templates/user_sessions/new"]

  events:
    'submit #new-user-session': 'save'

  constructor: (options) ->
    super(options)
    @model = new Slowmonster.Models.UserSession()

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.unset( 'errors' )

    @model.save @model.toJSON(),
      success: ( userSession ) =>
        window.location.hash = "/tasks"

      error: ( userSession, jqXHR ) =>
        console.log jqXHR

  render: ->
    $( @el ).html( @template( @model.toJSON() ) )
    this.$( 'form' ).backboneLink( @model )
    return this
