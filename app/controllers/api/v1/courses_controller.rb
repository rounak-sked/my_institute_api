module Api
  module V1
    class CoursesController < ApplicationController
      load_and_authorize_resource

      def index
        render json: @courses
      end

      def create
        @course = Course.new(course_params)
        # binding.break
        if @course.save
          render json: @course, status: :created
        else
          render json: { errors: @course.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @course.update(course_params)
          render json: @course
        else
          render json: { errors: @course.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @course.destroy
        head :no_content
      end

      private

      def course_params
        params.require(:course).permit(:name, :description, :duration, :status)
        end
    end
  end
end
