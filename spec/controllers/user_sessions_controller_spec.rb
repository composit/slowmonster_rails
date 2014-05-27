require 'spec_helper'

describe UserSessionsController do
  context 'POST' do
    let( :user ) { stub_model User, id: 123 }

    context 'if a user is found by the username' do
      before :each do
        User.stub( :where ).with( username: "testuser" ) { [user] }
      end

      describe 'if the params authenticate' do
        before :each do
          user.stub( :authenticate ).with( "testpass" ) { user }
          user.stub(:create_auth_token!) { :auth_token_stub }
          post :create, { user_session: { username: "testuser", password: "testpass" } }
        end

        it 'sets the session user' do
          expect( cookies.signed[:user_token] ).to eq :auth_token_stub
        end

        it 'redirects to the root url' do
          expect( response ).to redirect_to root_url
        end
      end

      describe 'if the params do not authenticate' do
        before :each do
          user.stub( :authenticate ).with( "testpass" ) { false }
          post :create, { user_session: { username: "testuser", password: "testpass" } }
        end

        it 'does not set the session user' do
          expect( cookies.signed[:user_token] ).to be_nil
        end

        it 'returns an unprocessable entity status' do
          expect( response.status ).to eq 422
        end
      end
    end

    describe 'when no user is found with the given username' do
      before :each do
        User.stub( :where ).with( username: "testuser" ) { [] }
        post :create, { user_session: { username: "testuser", password: "testpass" } }
      end

      it 'does not set the session user' do
        expect( cookies.signed[:user_token] ).to be_nil
      end

      it 'returns an unprocessable entity status' do
        expect( response.status ).to eq 422
      end
    end
  end

  context 'DELETE' do
    before :each do
      create(:auth_token, token: 123)
      cookies.signed[:user_token] = 123
      delete :destroy
    end
    
    it 'clears the user id from the session' do
      expect( cookies.signed[:user_token] ).to be_nil
    end

    it 'deletes the auth_token' do
      expect(AuthToken.count).to eq 0
    end

    it 'responds with a status of "OK"' do
      expect(response).to redirect_to root_url
    end
  end
end
