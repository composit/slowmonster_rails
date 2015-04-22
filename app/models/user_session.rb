class UserSession
  # once in rails 4, just use ActiveModel::Model
  # include ActiveModel::Model
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :username, :password, :remember_me

  def initialize(attributes = {})
    attributes.each do |name, value|
      public_send("#{name}=", value)
    end
  end

  def persisted?
    false
  end
end
