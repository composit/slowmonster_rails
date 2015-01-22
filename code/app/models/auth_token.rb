class AuthToken < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :user, :token
  validates_uniqueness_of :token, allow_blank: true
end
