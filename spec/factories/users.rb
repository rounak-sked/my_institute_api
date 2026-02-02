# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { "password123" }
    password_confirmation { "password123" }
    name { "Test User" }
    role { "student" } # default role

    trait :student do
      role { "student" }
    end

    trait :faculty do
      role { "faculty" }
    end

    trait :admin do
      role { "admin" }
    end
  end
end

