class Enrollment < ApplicationRecord
  belongs_to :batch
  belongs_to :student, class_name: "User"

  STATUSES = %w[pending approved rejected].freeze

  validates :status, inclusion: { in: STATUSES }
  validates :student_id, uniqueness: { scope: :batch_id }
  validates :batch, :student, presence: true
end
