describe 'user session new view', ->
  beforeEach ->
    @view = new Slowmonster.Views.UserSessions.NewView

  afterEach ->

  describe 'instantiation', ->
    it 'builds a new user session object', ->
      expect( @view.model ).toBeDefined()

  describe 'render', ->
    xit 'appends the form to the user-session div'

  describe 'save', ->
    beforeEach ->
      @$el = $( @view.render().el )
      @server = sinon.fakeServer.create()

    afterEach ->
      @server.restore()

    it 'saves on submit', ->
      saveSpy = sinon.spy Slowmonster.Views.UserSessions.NewView.prototype, 'save'
      view = new Slowmonster.Views.UserSessions.NewView
      $el = $( view.render().el )
      $el.find( 'form' ).submit()
      expect( saveSpy ).toHaveBeenCalledOnce()
      saveSpy.restore()

    it 'removes old errors', ->
      setSpy = sinon.spy @view.model, 'set'
      @$el.find( 'form' ).submit()
      expect( setSpy ).toHaveBeenCalledWith( 'errors', [] )

    it 'posts the model attributes', ->
      saveSpy = sinon.spy @view.model, 'save'
      @server.respondWith 'POST', '/user_sessions', [200, { 'Content-Type': 'application/json' }, '']
      @$el.find( 'form' ).submit()
      @server.respond()
      expect( saveSpy ).toHaveBeenCalledOnce()

    describe 'success', ->
      xit 'redirects to the root path', ->
        @server.respondWith 'POST', '/user_sessions', [200, { 'Content-Type': 'application/json' }, '']
        @$el.find( 'form' ).submit()
        @server.respond()
        expect( window.location.href ).toEqual '/'

    describe 'error', ->
      it 'sets the error', ->
        setSpy = sinon.spy @view.model, 'set'
        @server.respondWith "POST", "/user_sessions", [406, { "Content-Type": "application/json" }, 'incorrect username or password']
        @$el.find( 'form' ).submit()
        @server.respond()
        expect( setSpy ).toHaveBeenCalledWith errors: 'incorrect username or password'

      it 're-renders the view', ->
        renderSpy = sinon.spy @view, 'render'
        @server.respondWith "POST", "/user_sessions", [406, { "Content-Type": "application/json" }, '{"errors":{"username":["can\'t be blank"]}}']
        @$el.find( 'form' ).submit()
        @server.respond()
        expect( renderSpy ).toHaveBeenCalled()
