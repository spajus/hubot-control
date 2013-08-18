FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "testuser#{n}@example.com" }
    password 'testuser123'
  end

  factory :hubot do
    sequence(:name) { |n| "hubot#{n}" }
    sequence(:title) { |n| "Hubot ##{n}" }
    sequence(:port) { |n| 8000 + n }
    sequence(:test_port) { |n| 9000 + n }
    adapter 'shell'
  end
end
