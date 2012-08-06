class User < ActiveRecord::Base
  attr_accessible :email, :password, :password_confirmation, :username
  validates :username, presence: true, uniqueness: true

  has_many :tasks
end
