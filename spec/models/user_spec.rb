require 'spec_helper'

describe User do
  it 'is valid' do
    expect( build( :user ) ).to be_valid
  end

  it 'persists the username' do
    user = create :user, username: 'testuser'
    expect( user.reload.username ).to eq 'testuser'
  end

  context 'username' do
    it 'requires a username' do
      user = build :user, username: nil
      expect( user ).to_not be_valid
      expect( user.errors.full_messages ).to eq ['Username can\'t be blank']
    end

    it 'requires a unique username' do
      create :user, username: 'testuser'
      user = build :user, username: 'testuser'
      expect( user ).to_not be_valid
      expect( user.errors.full_messages ).to eq ['Username has already been taken']
    end
  end

  context 'password' do
    it 'requires a password' do
      user = build :user, password: nil
      expect( user ).to_not be_valid
      expect( user.errors.full_messages ).to eq ['Password can\'t be blank']
    end

    it 'does not override the password if a blank password is passed' do
      user = create :user, password: 'testpass'
      user.update_attributes! password: ''
      expect( user.authenticate 'testpass' ).to be_true
    end

    it 'requires a password confirmation to match the password' do
      user = build :user, password: 'testpass', password_confirmation: 'otherpass'
      expect( user ).to_not be_valid
      expect( user.errors.full_messages ).to eq ['Password doesn\'t match confirmation']
    end

    context 'authentication' do
      let( :user ) { build :user, password: 'testpass' }
      specify { expect( user.authenticate 'testpass' ).to be_true }
      specify { expect( user.authenticate 'otherpass' ).to be_false }
    end
  end

  it 'persists many tasks' do
    user = create :user
    3.times { user.tasks << build( :task ) }
    expect( user.reload.tasks.length ).to eq 3
  end

  it 'returns the current task time' do
    user = create :user
    task = create :task, user: user
    time_1 = create :task_time, task: task, started_at: 1.day.ago, ended_at: 12.hours.ago
    time_2 = create :task_time, task: task, started_at: 1.day.ago, ended_at: nil
    time_3 = create :task_time, task: task, started_at: 2.days.ago, ended_at: 1.day.ago
    expect( user.reload.current_task_time ).to eq time_2
  end
end
