require "rails_helper"

RSpec.describe "Authentication", type: :request do
  let!(:student) do
    create(
      :user,
      email: "student@test.com",
      password: "password",
      role: :student
    )
  end

  describe "POST /signup" do
    it "signs up a student" do
      post "/signup", params: {
        user: {
          email: "newstudent@test.com",
          password: "password",
          password_confirmation: "password",
          role: "student"
        }
      }

      expect(response).to have_http_status(:created)
      expect(User.last.student?).to be true
    end
  end

  describe "POST /login" do
    it "logs in a student" do
      post "/login", params: {
        user: {
          email: student.email,
          password: "password"
        }
      }

      expect(response).to have_http_status(:ok)
      expect(response.headers["Authorization"]).to be_present
    end
  end

  describe "DELETE /logout" do
    it "logs out a logged-in user" do
      # login first → this is IMPORTANT for JWT
      post "/login", params: {
        user: {
          email: student.email,
          password: "password"
        }
      }

      token = response.headers["Authorization"]

      delete "/logout", headers: {
        "Authorization" => token
      }

      expect(response).to have_http_status(:ok)

      body = JSON.parse(response.body)
      expect(body["message"]).to eq("User logged out successfully")
    end
  end
end
