require "rails_helper"

RSpec.describe "API V1 Enrollments", type: :request do
  let(:course)  { create(:course) }
  let(:faculty) { create(:user, :faculty) }
  let(:student) { create(:user, :student) }
  let(:admin)   { create(:user, :admin) }

  let!(:batch) { create(:batch, course: course) }

  let(:valid_params) do
    {
      enrollment: {
        batch_id: batch.id
      }
    }
  end

  # -------------------------------
  # GET /api/v1/enrollments
  # -------------------------------
  describe "GET /api/v1/enrollments" do
    let!(:enrollment1) { create(:enrollment, batch: batch, student: student) }
    let!(:enrollment2) { create(:enrollment, batch: batch) }

    context "as student" do
      before do
        sign_in student
        get "/api/v1/enrollments"
      end

      it "returns all enrollments" do
        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body.size).to eq(2)
      end
    end

    context "as faculty" do
      before do
        sign_in faculty
        get "/api/v1/enrollments"
      end

      it "returns all enrollments" do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(2)
      end
    end

    context "as admin" do
      before do
        sign_in admin
        get "/api/v1/enrollments"
      end

      it "returns all enrollments" do
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body).size).to eq(2)
      end
    end
  end

  # -------------------------------
  # POST /api/v1/enrollments
  # -------------------------------
  describe "POST /api/v1/enrollments" do
    context "as student" do
      before { sign_in student }

      it "creates an enrollment" do
        expect {
          post "/api/v1/enrollments", params: valid_params
        }.to change(Enrollment, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end

    context "as faculty" do
      before { sign_in faculty }

      it "is forbidden" do
        post "/api/v1/enrollments", params: valid_params
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "as admin" do
      before { sign_in admin }

      it "creates an enrollment" do
        expect {
          post "/api/v1/enrollments", params: valid_params
        }.to change(Enrollment, :count).by(1)

        expect(response).to have_http_status(:created)
      end
    end
  end

  # -------------------------------
  # PATCH /approve
  # -------------------------------
  describe "PATCH /api/v1/enrollments/:id/approve" do
    let!(:enrollment) { create(:enrollment, batch: batch, status: "pending") }

    context "as faculty" do
      before do
        sign_in faculty
        patch "/api/v1/enrollments/#{enrollment.id}/approve"
      end

      it "approves enrollment" do
        expect(response).to have_http_status(:ok)
        expect(enrollment.reload.status).to eq("approved")
      end
    end

    context "as student" do
      before do
        sign_in student
        patch "/api/v1/enrollments/#{enrollment.id}/approve"
      end

      it "is forbidden" do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "as admin" do
      before do
        sign_in admin
        patch "/api/v1/enrollments/#{enrollment.id}/approve"
      end

      it "approves enrollment" do
        expect(enrollment.reload.status).to eq("approved")
      end
    end
  end

  # -------------------------------
  # PATCH /reject
  # -------------------------------
  describe "PATCH /api/v1/enrollments/:id/reject" do
    let!(:enrollment) { create(:enrollment, batch: batch, status: "pending") }

    context "as faculty" do
      before do
        sign_in faculty
        patch "/api/v1/enrollments/#{enrollment.id}/reject"
      end

      it "rejects enrollment" do
        expect(response).to have_http_status(:ok)
        expect(enrollment.reload.status).to eq("rejected")
      end
    end

    context "as student" do
      before do
        sign_in student
        patch "/api/v1/enrollments/#{enrollment.id}/reject"
      end

      it "is forbidden" do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "as admin" do
      before do
        sign_in admin
        patch "/api/v1/enrollments/#{enrollment.id}/reject"
      end

      it "rejects enrollment" do
        expect(enrollment.reload.status).to eq("rejected")
      end
    end
  end
end
