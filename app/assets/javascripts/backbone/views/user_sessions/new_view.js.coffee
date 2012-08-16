Slowmonster.Views.UserSessions ||= {}

class Slowmonster.Views.UserSessions.NewView extends Backbone.View
  template: JST["backbone/templates/user_sessions/new"]

  events:
    'submit #new-user-session': 'save'

  constructor: (options) ->
    super(options)
    @model = new Slowmonster.Models.UserSession()

    @model.bind 'change:errors', =>
      @render()

  save: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @model.set( 'errors', [] )

    @model.save @model.toJSON(),
      success: ( userSession ) =>
        window.location = "/"

      error: ( userSession, jqXHR ) =>
        @model.set({errors: $.parseJSON(jqXHR.responseText)})

  render: ->
    $( @el ).html( @template( @model.toJSON() ) )
    this.$( 'form' ).backboneLink( @model )
    return this
