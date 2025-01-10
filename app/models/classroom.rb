class Classroom < ApplicationRecord
  has_many :sections, dependent: :destroy

  validates :name, :capacity, presence: true
  validates :capacity, numericality: {greater_than: 0}
  validates :name, uniqueness: {case_sensitive: false}
end
