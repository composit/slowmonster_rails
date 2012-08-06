require 'spec_helper'

describe User do
  it 'is valid' do
    build( :user ).should be_valid
  end

  it 'persists the username' do
    user = create :user, username: 'testuser'
    user.reload.username.should == 'testuser'
  end

  context 'username' do
    it 'requires a username' do
      user = build :user, username: nil
      user.should_not be_valid
      user.errors.full_messages.should == ['Username can\'t be blank']
    end

    it 'requires a unique username' do
      create :user, username: 'testuser'
      user = build :user, username: 'testuser'
      user.should_not be_valid
      user.errors.full_messages.should == ['Username has already been taken']
    end
  end

  context 'password' do
    it 'requires a password' do
      user = build :user, password: nil
      user.should_not be_valid
      user.errors.full_messages.should == ['Password can\'t be blank']
    end

    it 'does not override the password if a blank password is passed' do
      user = create :user, password: 'testpass'
      user.update_attributes! password: ''
      user.authenticate( 'testpass' ).should be_true
    end

    it 'requires a password confirmation to match the password' do
      user = build :user, password: 'testpass', password_confirmation: 'otherpass'
      user.should_not be_valid
      user.errors.full_messages.should == ['Password doesn\'t match confirmation']
    end

    context 'authentication' do
      let( :user ) { build :user, password: 'testpass' }
      specify { user.authenticate( 'testpass' ).should be_true }
      specify { user.authenticate( 'otherpass' ).should be_false }
    end
  end

  it 'persists many tasks' do
    user = create :user
    3.times { user.tasks << build( :task ) }
    user.reload.tasks.length.should == 3
  end
end
