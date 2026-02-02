require "rails_helper"

RSpec.describe JwtDenylist, type: :model do
  it "stores revoked tokens" do
    denylist = JwtDenylist.create!(
      jti: SecureRandom.uuid,
      exp: 1.day.from_now
    )

    expect(denylist).to be_persisted
  end
end