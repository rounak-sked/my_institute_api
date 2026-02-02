class BatchesController < ApplicationController
  def index
    authorize! :read, Batch

    batches = Batch.all

    render json: batches, status: :ok
  end

  def create
    authorize! :create, Batch

    batch = Batch.new(batch_params)

    if batch.save
      render json: batch, status: :created
    else
      render json: { errors: batch.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  private

  def batch_params
    params.require(:batch).permit(
      :name,
      :start_date,
      :end_date,
      :course_id,
      :faculty_id
    )
  end
end
