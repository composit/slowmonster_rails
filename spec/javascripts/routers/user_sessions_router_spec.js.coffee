describe 'user sessions router', ->
  beforeEach ->
    @router = new Slowmonster.Routers.UserSessionsRouter()
    @routeSpy = sinon.spy()
    try
      Backbone.history.start silent: true
    catch e

  describe 'login', ->
    it 'fires the newUserSession route', ->
      @router.on 'route:newUserSession', @routeSpy
      @router.navigate 'login', trigger: true
      expect( @routeSpy ).toHaveBeenCalledOnce()

    it 'renders the new view', ->
      newUserSessionViewStub = sinon.stub( Slowmonster.Views.UserSessions, 'NewView' ).returns new Backbone.View()
      @router.newUserSession()
      expect( newUserSessionViewStub ).toHaveBeenCalled()
      newUserSessionViewStub.restore()
