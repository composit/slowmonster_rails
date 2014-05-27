class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :username
  validates :username, presence: true, uniqueness: true

  has_secure_password

  has_many :tasks
  has_many :task_times, through: :tasks
  has_many :auth_tokens

  def current_task_times
    task_times.current
  end

  def create_auth_token!
    new_token = SecureRandom.urlsafe_base64
    auth_token = AuthToken.new
    auth_token.user = self
    auth_token.token = new_token
    auth_token.save!
    new_token
  end
end
