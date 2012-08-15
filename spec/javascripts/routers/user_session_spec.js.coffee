describe 'user session routes', ->
  beforeEach ->
    @router = new Slowmonster.Routers.UserSessions()
    @routeSpy = sinon.spy()
    try
      Backbone.history.start { silent: true }
      Backbone.history.started = true
    catch e
    @router.navigate 'elsewhere'

  describe 'new', ->
    beforeEach ->
      @userSessionViewStub = sinon.stub( Slowmonster.Views, 'UserSession' ).returns new Backbone.View()

    afterEach ->
      Slowmonster.Views.UserSession.restore()

    it 'fires the new route', ->
      @router.on 'route:new', @routeSpy
      @router.navigate 'login', { trigger: true }
      expect( @routeSpy ).toHaveBeenCalledOnce()

    it 'renders the new view', ->
      @router.new()
      expect( @userSessionViewStub ).toHaveBeenCalledOnce()
