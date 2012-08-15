describe Slowmonster.Models.UserSession, ->
  describe 'when instantiated', ->
    beforeEach ->
      @userSession = new Slowmonster.Models.UserSession

    it 'exhibits attributes', ->
      @userSession.set username: 'testuser'
      expect( @userSession.get 'username' ).toEqual 'testuser'

    it 'sets the url to user_sessions', ->
      expect( @userSession.url() ).toEqual '/user_sessions'
