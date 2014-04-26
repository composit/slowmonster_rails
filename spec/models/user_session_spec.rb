require 'spec_helper'

describe UserSession do
  it 'initializes with attributes' do
    user_session = UserSession.new(username: 'testuser', password: 'testpass', remember_me: true)
    expect(user_session.username).to eq('testuser')
  end
end
