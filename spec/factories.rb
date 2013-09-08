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

  factory :git_sync do
    repo 'git://github.com/foo/bar.git'
    user_name 'Foo Bar'
    user_email 'foo.bar@example.com'
    factory :git_sync_scripts do
      target 'scripts'
    end
  end

end
