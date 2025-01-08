class Classroom < ApplicationRecord
  has_many :sections, dependent: :destroy

  validates :name, :capacity, presence: true
end
