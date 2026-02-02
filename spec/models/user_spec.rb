require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it "is valid with valid attributes" do
    expect(user).to be_valid
  end

  it "can be admin" do
    admin = build(:user, :admin)
    expect(admin.role).to eq("admin")
  end

  it "can be faculty" do
    faculty = build(:user, :faculty)
    expect(faculty.role).to eq("faculty")
  end

  it "can be student" do
    student = build(:user, :student)
    expect(student.role).to eq("student")
  end
end
