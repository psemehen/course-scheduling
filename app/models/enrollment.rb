class Enrollment < ApplicationRecord
  belongs_to :student
  belongs_to :subject
  belongs_to :section

  validates :student_id, uniqueness: {
    scope: [:subject_id, :section_id],
    message: "is already enrolled in this section of the subject"
  }
end
