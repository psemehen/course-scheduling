class Enrollment < ApplicationRecord
  belongs_to :student
  belongs_to :subject
  belongs_to :section

  scope :overlapping_with, ->(section, exclude_id = nil) {
    joins(:section)
      .where.not(id: exclude_id)
      .where(section: Section.overlapping_sections(section))
  }

  validates :student_id, uniqueness: {
    scope: [:subject_id, :section_id],
    message: "is already enrolled in this section of the subject"
  }
  validates_with NoOverlapValidator
end
