# app/controllers/test_controller.rb
class TestController < ApplicationController
  def index
    render json: {
      message: "Authenticated",
      current_user: {
        id: current_user.id,
        email: current_user.email,
        type: current_user.type
      }
    }
  end
end
