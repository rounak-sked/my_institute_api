module Users
  class RegistrationsController < Devise::RegistrationsController
    skip_before_action :authenticate_user!, only: [:create]

    def create
      # binding.break
      build_resource(sign_up_params)

      # Allow only student or faculty roles (never admin)
      allowed_roles = %w[student faculty]
      requested_role = params.dig(:user, :role ,:name)

      resource.role =
        if allowed_roles.include?(requested_role)
          requested_role
        else
          "student"
        end

      if resource.save
        render json: {
          message: "Signup successful",
          user: user_payload(resource)
        }, status: :created
      else
        render json: {
          errors: resource.errors.full_messages
        }, status: :unprocessable_entity
      end
    end

    private

    def sign_up_params
      params.require(:user).permit(
        :email,
        :password,
        :password_confirmation,
        :name,
        :role
      )
    end

    def user_payload(user)
      {
        id: user.id,
        email: user.email,
        role: user.role,
        name: user.name
      }
    end
  end
end
