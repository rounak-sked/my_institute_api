class Course < ApplicationRecord
  belongs_to :faculty, optional: true

  has_many :batches, dependent: :destroy

  validates :name, presence: true
end