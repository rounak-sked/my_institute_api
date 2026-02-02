require "rails_helper"

RSpec.describe "Courses API", type: :request do
  let(:faculty) { create(:user, :faculty) }
  let(:admin) { create(:user, :admin) }
  let(:student) { create(:user, :student) }

  let(:valid_attributes) do
    {
      name: "Ruby on Rails",
      description: "Learn Rails from scratch",
      duration: "3 months",
      status: "active"
    }
  end

  let(:invalid_attributes) do
    {
      name: "",
      description: "",
      duration: "",
      status: ""
    }
  end

  # Helper to include JWT token
  def auth_headers(user)
    token = JwtHelper.generate_token(user)
    { "Authorization" => "Bearer #{token}" }
  end

  describe "GET /courses" do
    let!(:course) { create(:course) }

    it "returns all courses for admin" do
      get "/courses", headers: auth_headers(admin)
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).first["id"]).to eq(course.id)
    end

    it "returns all courses for faculty" do
      get "/courses", headers: auth_headers(faculty)
      expect(response).to have_http_status(:ok)
    end

    it "returns all courses for student" do
      get "/courses", headers: auth_headers(student)
      expect(response).to have_http_status(:ok)
    end
  end

  describe "POST /courses" do
    context "as faculty" do
      it "creates a course with valid attributes" do
        expect {
          post "/courses", params: { course: valid_attributes }, headers: auth_headers(faculty)
        }.to change(Course, :count).by(1)
        expect(response).to have_http_status(:created)
      end

      it "does not create a course with invalid attributes" do
        post "/courses", params: { course: invalid_attributes }, headers: auth_headers(faculty)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "as student" do
      it "is forbidden to create course" do
        post "/courses", params: { course: valid_attributes }, headers: auth_headers(student)
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
