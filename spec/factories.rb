FactoryGirl.define do
  sequence( :username ) { |n| "user#{n}" }

  factory :task do
    content 'something'
  end

  factory :user do
    username
    password 'testpass'
  end
end
