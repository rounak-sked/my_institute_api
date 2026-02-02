FactoryBot.define do
  factory :enrollment do
    association :batch
    association :student, factory: [:user, :student]
    status { "pending" }
  end
end
