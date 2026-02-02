FactoryBot.define do
  factory :jwt_denylist do
    jti { "MyString" }
    exp { "2026-01-27 12:35:54" }
  end
end
