class ApplicationController < ActionController::API
  before_action :authenticate_user!
  
  rescue_from CanCan::AccessDenied do |exception|
    render json: {
      error: "Access denied",
      message: exception.message
    }, status: :forbidden
  end
end