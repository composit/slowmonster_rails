FactoryGirl.define do
  sequence( :username ) { |n| "user#{n}" }

  factory :task do
    user
    content 'something'
  end

  factory :task_joiner do
    association :parent_task, factory: :task
    association :child_task, factory: :task
  end

  factory :task_time do
    task
    started_at Time.zone.now
  end

  factory :user do
    username
    password 'testpass'
  end
end
