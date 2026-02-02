class EnrollmentsController < ApplicationController
  def index
    authorize! :read, Enrollment

    enrollments =
      if current_user.is_a?(Admin)
        Enrollment.all
      elsif current_user.is_a?(Faculty)
        Enrollment.joins(:batch)
                  .where(batches: { faculty_id: current_user.id })
      else 
        current_user.enrollments
      end

    render json: enrollments, status: :ok
  end

  def create
    authorize! :create, Enrollment

    enrollment = Enrollment.new(
      student_id: current_user.id,
      batch_id: enrollment_params[:batch_id],
      status: "pending"
    )

    if enrollment.save
      render json: enrollment, status: :created
    else
      render json: { errors: enrollment.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def approve
    # binding.break
    enrollment = Enrollment.find(params[:id])
    authorize! :update, enrollment

    enrollment.approve!

    render json: {
      message: "Enrollment approved",
      enrollment: enrollment
    }, status: :ok
  end

  def reject
    enrollment = Enrollment.find(params[:id])
    authorize! :update, enrollment

    enrollment.reject!

    render json: {
      message: "Enrollment rejected",
      enrollment: enrollment
    }, status: :ok
  end

  private

  def enrollment_params
    params.require(:enrollment).permit(:batch_id)
  end
end
