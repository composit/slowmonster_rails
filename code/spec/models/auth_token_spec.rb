require 'spec_helper'

describe AuthToken do
  it 'persists a token' do
    auth_token = create(:auth_token, token: 'testtoken')
    expect(auth_token.reload.token).to eq('testtoken')
  end

  it 'belongs to a user' do
    user = create(:user)
    auth_token = create(:auth_token, user: user)
    expect(auth_token.reload.user).to eq(user)
  end

  it 'requires a token' do
    auth_token = build(:auth_token, token: nil)
    expect(auth_token).to_not be_valid
    expect(auth_token.errors.full_messages).to eq ['Token can\'t be blank']
  end

  it 'requires a user' do
    auth_token = build(:auth_token, user: nil)
    expect(auth_token).to_not be_valid
    expect(auth_token.errors.full_messages).to eq ['User can\'t be blank']
  end

  it 'requires a unique token' do
    create(:auth_token, token: 'abc123')
    auth_token = build(:auth_token, token: 'abc123')
    expect(auth_token).to_not be_valid
    expect(auth_token.errors.full_messages).to eq ['Token has already been taken']
  end
end
