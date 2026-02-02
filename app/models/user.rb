class User < ApplicationRecord
  self.inheritance_column = :_type_disabled
  devise :database_authenticatable,       # Authenticate users with email/password stored in the database
        :registerable,                   # Allow users to sign up, edit account, and delete account
        :jwt_authenticatable,            # Use JWT tokens for API authentication instead of sessions/cookies
        jwt_revocation_strategy: JwtDenylist  # Revoke JWTs on logout by storing revoked tokens in JwtDenylist
  ROLES = %w[admin faculty student].freeze
  has_one_attached :profile_image
  validates :role, presence: true, inclusion: { in: ROLES }
  validates :profile_image,
    content_type: ['image/jpeg', 'image/png'],
    size: { less_than: 2.megabytes }
  # Role helpers
  def admin?
    role == "admin"
  end

  def faculty?
    role == "faculty"
  end

  def student?
    role == "student"
  end
end
