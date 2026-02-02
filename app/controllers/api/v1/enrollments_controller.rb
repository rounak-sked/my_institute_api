module Api
  module V1
    class EnrollmentsController < ApplicationController
      load_and_authorize_resource

      def index
        # binding.break
        @enrollment = Enrollment.all
        render json: @enrollment
      end


      def create
        @enrollment.student = current_user
        @enrollment.status = "pending"

        if @enrollment.save
          render json: @enrollment, status: :created
        else
          render json: { errors: @enrollment.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def approve
        authorize! :update, @enrollment

        @enrollment.update!(status: "approved")
        render json: { message: "Enrollment approved" }
      end

      def reject
        authorize! :update, @enrollment

        @enrollment.update!(status: "rejected")
        render json: { message: "Enrollment rejected" }
      end
  
      private

      def enrollment_params
        params.require(:enrollment).permit(:batch_id)
      end
    end
  end
end
