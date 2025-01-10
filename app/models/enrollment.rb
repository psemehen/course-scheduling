class Enrollment < ApplicationRecord
  belongs_to :student
  belongs_to :subject
  belongs_to :section

  delegate :full_name, to: :student, prefix: true
  delegate :full_name, to: :teacher, prefix: true
  delegate :name, :start_time, :end_time, :days_of_week, :duration, to: :section, prefix: true
  delegate :name, to: :subject, prefix: true

  validates :student_id, uniqueness: {
    scope: [:subject_id, :section_id],
    message: "is already enrolled in this section of the subject"
  }
  validate :no_schedule_overlap

  scope :overlapping_with, ->(section, exclude_id = nil) {
    joins(:section)
      .where.not(id: exclude_id)
      .where("sections.days_of_week = ? OR sections.days_of_week = ? OR ? = ?",
        Section.days_of_weeks[section.days_of_week], Section.days_of_weeks[:everyday],
        Section.days_of_weeks[:everyday], Section.days_of_weeks[section.days_of_week])
      .where("(sections.start_time < ? AND sections.end_time > ?) OR (? < sections.end_time AND ? > sections.start_time)",
        section.end_time, section.start_time, section.start_time, section.end_time)
  }

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
