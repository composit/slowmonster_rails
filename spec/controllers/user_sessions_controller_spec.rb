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
          user.stub(:update_auth_token!) { :auth_token_stub }
          post :create, { user_session: { username: "testuser", password: "testpass" }, format: :json }
        end

        it 'sets the session user' do
          expect( cookies[:user_token] ).to eq :auth_token_stub
        end

        it 'returns a status of "OK"' do
          expect( response.status ).to eq 201
        end
      end

      describe 'if the params do not authenticate' do
        before :each do
          user.stub( :authenticate ).with( "testpass" ) { false }
          post :create, { user_session: { username: "testuser", password: "testpass" }, format: :json }
        end

        it 'does not set the session user' do
          expect( cookies[:user_token] ).to be_nil
        end

        it 'returns an unprocessable entity status' do
          expect( response.status ).to eq 422
        end
      end
    end

    describe 'when no user is found with the given username' do
      before :each do
        User.stub( :where ).with( username: "testuser" ) { [] }
        post :create, { user_session: { username: "testuser", password: "testpass" }, format: :json }
      end

      it 'does not set the session user' do
        expect( cookies[:user_token] ).to be_nil
      end

      it 'returns an unprocessable entity status' do
        expect( response.status ).to eq 422
      end
    end
  end

  context 'DELETE' do
    before :each do
      cookies[:user_token] = 123
      delete :destroy, { id: "123", format: :json }
    end
    
    it 'clears the user id from the session' do
      expect( cookies[:user_token] ).to be_nil
    end

    it 'responds with a status of "OK"' do
      expect( response.status ).to eq 204
    end
  end
end
