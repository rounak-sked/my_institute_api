require "rails_helper"

RSpec.describe "Batches API", type: :request do
  let(:course) { create(:course) }
  let(:faculty) { create(:user, :faculty) }
  let(:admin) { create(:user, :admin) }
  let(:student) { create(:user, :student) }

  let(:valid_attributes) do
    {
      name: "Evening Batch",
      start_date: Date.today,
      end_date: Date.today + 3.months,
      course_id: course.id,
      faculty_id: faculty.id
    }
  end

  let(:invalid_attributes) do
    {
      name: "",
      start_date: Date.today,
      end_date: Date.today - 1.day,
      course_id: nil
    }
  end

  # Helper to include JWT token
  def auth_headers(user)
    token = JwtHelper.generate_token(user) # your helper from spec/support/jwt_helper.rb
    { "Authorization" => "Bearer #{token}" }
  end

  describe "GET /batches" do
    let!(:batch) { create(:batch, faculty: faculty, course: course) }

    it "returns all batches for admin" do
      get "/batches", headers: auth_headers(admin)
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).first["id"]).to eq(batch.id)
    end

    it "returns all batches for faculty" do
      get "/batches", headers: auth_headers(faculty)
      expect(response).to have_http_status(:ok)
    end


  end

  describe "POST /batches" do
    context "as faculty" do
      it "creates a batch with valid attributes" do
        expect {
          post "/batches", params: { batch: valid_attributes }, headers: auth_headers(faculty)
        }.to change(Batch, :count).by(1)
        expect(response).to have_http_status(:created)
      end

      it "does not create a batch with invalid attributes" do
        post "/batches", params: { batch: invalid_attributes }, headers: auth_headers(faculty)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "as student" do
      it "is forbidden to create batch" do
        post "/batches", params: { batch: valid_attributes }, headers: auth_headers(student)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end



end
