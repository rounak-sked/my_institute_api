# spec/models/ability_spec.rb
require 'rails_helper'

RSpec.describe Ability, type: :model do
  context "when admin" do
    let(:user) { create(:user, :admin) }  # use trait

    it "can manage all" do
      expect(Ability.new(user)).to be_able_to(:manage, :all)
    end
  end

  context "when student" do
    let(:user) { create(:user, :student) }  # use trait

    it "can read course" do
      expect(Ability.new(user)).to be_able_to(:read, Course.new)
    end

    it "cannot create course" do
      expect(Ability.new(user)).not_to be_able_to(:create, Course.new)
    end
  end
end