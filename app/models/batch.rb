class Batch < ApplicationRecord
  belongs_to :course
  belongs_to :faculty, class_name: "User", optional: true  # optional if faculty_id can be null
  has_many :enrollments, dependent: :destroy

  has_many :enrollments

  validates :name, :start_date, :end_date, presence: true
  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?
    errors.add(:end_date, "must be after start date") if end_date < start_date
  end
end