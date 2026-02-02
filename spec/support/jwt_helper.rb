# spec/support/jwt_helper.rb
module JwtHelper
  require 'jwt'

  SECRET_KEY = Rails.application.credentials.secret_key_base || Rails.application.secrets.secret_key_base

  # Returns a JWT token for a given user
  def jwt_for(user)
    payload = { user_id: user.id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, SECRET_KEY)
  end
  def auth_headers(user)
    token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
    { "Authorization" => "Bearer #{token}" }
  end
  # Generate a valid JWT token for a given user
  def self.generate_token(user)
    Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
  end
end

