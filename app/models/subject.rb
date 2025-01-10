class Subject < ApplicationRecord
  has_many :sections, dependent: :destroy
  has_many :teachers, through: :sections
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments

  validates :name, presence: true, uniqueness: {case_sensitive: false}
end
