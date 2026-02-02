require "rails_helper"

RSpec.describe Course, type: :model do
  let(:course) { build(:course) }

  it "is valid with valid attributes" do
    expect(course).to be_valid
  end

  it "can have many batches" do
    batch1 = create(:batch, course: course)
    batch2 = create(:batch, course: course)
    expect(course.batches).to include(batch1, batch2)
  end
end
