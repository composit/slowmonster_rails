class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :username
  validates :username, presence: true, uniqueness: true

  has_secure_password

  has_many :tasks
  has_many :task_times, through: :tasks

  def current_task_times
    task_times.current
  end

  def update_auth_token!
    new_token = SecureRandom.urlsafe_base64
    update_attribute(:auth_token, new_token)
    new_token
  end
end
