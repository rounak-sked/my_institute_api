require "rails_helper"

RSpec.describe Batch, type: :model do
  let(:batch) { build(:batch) }

  it "is valid with valid attributes" do
    expect(batch).to be_valid
  end

  it "belongs to a course" do
    expect(batch.course).to be_present
  end

  it "is invalid without a name" do
    batch.name = nil
    expect(batch).not_to be_valid
    expect(batch.errors[:name]).to include("can't be blank")
  end

  it "is invalid if end_date is before start_date" do
    batch.end_date = batch.start_date - 1.day
    expect(batch).not_to be_valid
    expect(batch.errors[:end_date]).to include("must be after start date")
  end
end
