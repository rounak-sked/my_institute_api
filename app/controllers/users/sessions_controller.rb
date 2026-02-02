module Users
  class SessionsController < Devise::SessionsController
    respond_to :json

    skip_before_action :authenticate_user!, only: [:create]

    def create
      # binding.break
      # Safely fetch user params
      email = params.dig(:user, :email)
      password = params.dig(:user, :password)

      user = User.find_by(email: email)

      if user&.valid_password?(password)
        sign_in(user)
        render json: {
          message: "Login successful",
          user: {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role # changed from `type` to `role`
          }
        }, status: :ok
      else
        render json: { error: "Invalid email or password" }, status: :unauthorized
      end
    end

    def destroy
      if current_user.nil?
        render json: {
          status: 401,
          error: "User already logged out or deleted"
        }, status: :unauthorized
      else
        sign_out(current_user)
        render json: {
          status: 200,
          message: "User logged out successfully"
        }, status: :ok
      end
    end
  end
end
