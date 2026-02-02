FactoryBot.define do
  factory :batch do
    name { "Morning Batch" }
    start_date { Date.today }
    end_date { Date.today + 3.months }

    # associations
    association :course

  end   # <-- closes factory block
end 