class Enrollment < ApplicationRecord
  belongs_to :student
  belongs_to :subject
  belongs_to :section
end
