class NoOverlapValidator < ActiveModel::Validator
  def validate(record)
    return unless record.section && record.student

    overlapping_enrollment = record.student.enrollments.overlapping_with(record.section, record.id).first

    return unless overlapping_enrollment

    record.errors.add(:base, I18n.t("errors.messages.enrollment_overlap",
      subject: overlapping_enrollment.subject.name,
      days: overlapping_enrollment.section.days_of_week.titleize,
      start_time: I18n.l(overlapping_enrollment.section.start_time, format: :time),
      end_time: I18n.l(overlapping_enrollment.section.end_time, format: :time)))
  end
end
