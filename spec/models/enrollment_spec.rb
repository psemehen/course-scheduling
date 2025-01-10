require "rails_helper"

RSpec.describe Enrollment, type: :model do
  describe "validations" do
    let(:enrollment) { build(:enrollment) }

    it "is valid with valid attributes" do
      expect(enrollment).to be_valid
    end

    describe "uniqueness validation" do
      let(:section) { create(:section, start_time: "2025-06-01 12:00:00", end_time: "2025-06-01 12:50:00") }
      let(:existing_enrollment) { create(:enrollment, section: section) }
      let(:duplicate_enrollment) {
        build(:enrollment, student: existing_enrollment.student,
          subject: existing_enrollment.subject, section: existing_enrollment.section)
      }
      let(:new_section) {
        create(:section, start_time: existing_enrollment.section.end_time + 10.minutes,
          end_time: existing_enrollment.section.end_time + 1.hour)
      }

      it "is invalid if student is already enrolled in the same section of the subject" do
        expect(duplicate_enrollment).to be_invalid
        expect(duplicate_enrollment.errors[:student_id]).to include("is already enrolled in this section of the subject")
      end

      it "is valid if student enrolls in a different section of the same subject" do
        new_enrollment = build(:enrollment,
          student: existing_enrollment.student,
          subject: existing_enrollment.subject)

        expect(new_enrollment).to be_valid
      end

      it "is valid if student enrolls in the same section of a different subject at a different time" do
        new_enrollment = build(:enrollment,
          student: existing_enrollment.student,
          section: new_section)

        expect(new_enrollment).to be_valid
      end

      it "is valid if a different student enrolls in the same section of the subject" do
        new_enrollment = build(:enrollment,
          subject: existing_enrollment.subject,
          section: existing_enrollment.section)

        expect(new_enrollment).to be_valid
      end
    end
  end
end
