require "rails_helper"

RSpec.describe Enrollment, type: :model do
  let(:enrollment) { build(:enrollment) }

  it "is valid with valid attributes" do
    expect(enrollment).to be_valid
  end

  it "belongs to a batch" do
    expect(enrollment.batch).to be_present
  end

  it "belongs to a student" do
    expect(enrollment.student.role).to eq("student")
  end

  it "is invalid without a batch" do
    enrollment.batch = nil
    expect(enrollment).not_to be_valid
  end

  it "is invalid without a student" do
    enrollment.student = nil
    expect(enrollment).not_to be_valid
  end
end
