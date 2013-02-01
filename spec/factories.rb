FactoryGirl.define do
  sequence( :username ) { |n| "user#{n}" }

  factory :report do
    started_at Time.zone.now
    unit 'day'
    duration 1
  end

  factory :report_task do
    report
    task
  end

  factory :task do
    user
    content 'something'
  end

  factory :task_amount do
    task
    amount 123
    incurred_at Time.zone.now
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
