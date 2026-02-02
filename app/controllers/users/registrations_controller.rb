require 'open-uri'  # Needed to download image from URL

module Users
  class RegistrationsController < Devise::RegistrationsController
    include Rails.application.routes.url_helpers  # for url_for

    skip_before_action :authenticate_user!, only: [:create]

    # Ensure url_for works in API-only mode
    def default_url_options
      { host: 'localhost', port: 3000 }
    end

    # POST /signup
    def create
      build_resource(sign_up_params)

      # Only allow student/faculty roles (never admin)
      allowed_roles = %w[student faculty]
      requested_role = params.dig(:user, :role)
      resource.role = allowed_roles.include?(requested_role) ? requested_role : 'student'

      # Attach profile image from URL if provided
      if params[:user][:profile_image_url].present?
        begin
          uri = URI.parse(params[:user][:profile_image_url])
          # Only allow common image extensions
          if uri.path =~ /\.(jpg|jpeg|png|gif)\z/i
            downloaded_image = URI.open(uri)
            filename = File.basename(uri.path)
            resource.profile_image.attach(io: downloaded_image, filename: filename)
          else
            Rails.logger.warn("Profile image URL is not a valid image: #{params[:user][:profile_image_url]}")
          end
        rescue => e
          Rails.logger.warn("Failed to download profile image: #{e.message}")
        end
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

    # Permit params
    def sign_up_params
      params.require(:user).permit(
        :email,
        :password,
        :password_confirmation,
        :name,
        :role
      )
    end

    # JSON payload including Active Storage URL
    def user_payload(user)
      {
        id: user.id,
        email: user.email,
        role: user.role,
        name: user.name,
        profile_image_url: user.profile_image.attached? ? url_for(user.profile_image) : nil
      }
    end
  end
end
