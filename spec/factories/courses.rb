FactoryBot.define do
  factory :course do
    name { "Ruby on Rails" }
    description { "Learn backend development with Rails" }
    duration { "3 months" }
    status { "active" }
  end
end