module Api
  module V1
    class BatchesController < ApplicationController
      load_and_authorize_resource

      def index
        @batches = Batch.all
        render json: @batches
      end

      def create
        @batch.faculty = current_user if current_user.faculty?

        if @batch.save
          render json: @batch, status: :created
        else
          render json: { errors: @batch.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @batch.update(batch_params)
          render json: @batch
        else
          render json: { errors: @batch.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @batch.destroy
        head :no_content
      end

      private

      def batch_params
        params.require(:batch).permit(:name, :start_date, :end_date, :course_id)
      end
    end
  end
end
