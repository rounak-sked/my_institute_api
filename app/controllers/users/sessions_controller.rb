module Users
  class SessionsController < Devise::SessionsController
    respond_to :json
    skip_before_action :authenticate_user!, only: [:create]

    include Rails.application.routes.url_helpers  # Needed for url_for

    def create
      email = params.dig(:user, :email)
      password = params.dig(:user, :password)

      user = User.find_by(email: email)

      if user&.valid_password?(password)
        sign_in(user)
  # binding.break
        render json: {
          message: "Login successful",
          user: {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role,
            profile_image_url: user.profile_image.attached? ? url_for(user.profile_image) : nil
          }
        }, status: :ok
      else
        render json: { error: "Invalid email or password" }, status: :unauthorized
      end
    end

    def destroy
      if current_user.nil?
        render json: { status: 401, error: "User already logged out or deleted" }, status: :unauthorized
      else
        sign_out(current_user)
        render json: { status: 200, message: "User logged out successfully" }, status: :ok
      end
    end
  end
end
