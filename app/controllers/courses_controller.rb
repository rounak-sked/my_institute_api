class CoursesController < ApplicationController
  def index
    authorize! :read, Course

    courses = Course.all

    render json: courses, status: :ok
  end

  def create
    # binding.break
    authorize! :create, Course

    course = Course.new(course_params)

    if course.save
      render json: course, status: :created
    else
      render json: {
        errors: course.errors.full_messages
      }, status: :unprocessable_entity
    end
  end

  private

  def course_params
    params.require(:course).permit(
      :name,
      :description,
      :duration,
      :status
    )
  end
end
