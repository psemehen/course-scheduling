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
  validate :no_schedule_overlap

  private

  def no_schedule_overlap
    return unless section && student

    overlapping_enrollment = student.enrollments.overlapping_with(section, id).first

    return unless overlapping_enrollment

    errors.add(:base, "This section overlaps with #{overlapping_enrollment.subject.name} " \
      "on #{overlapping_enrollment.section.days_of_week.titleize} " \
      "from #{overlapping_enrollment.section.start_time.strftime("%I:%M %p")} " \
      "to #{overlapping_enrollment.section.end_time.strftime("%I:%M %p")}")
  end
end
