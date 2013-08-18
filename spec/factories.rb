FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "testuser#{n}@example.com" }
    password 'testuser123'
  end

end
