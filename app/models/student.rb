class Student < ApplicationRecord
  include Personable

  has_many :enrollments, dependent: :destroy
  has_many :subjects, through: :enrollments
  has_many :sections, through: :enrollments
end
