require "rails_helper"

RSpec.describe Enrollment, type: :model do
  describe "validations" do
    let(:enrollment) { build(:enrollment) }

    it "is valid with valid attributes" do
      expect(enrollment).to be_valid
    end

    describe "uniqueness validation" do
      let(:existing_enrollment) { create(:enrollment) }

      it "is invalid if student is already enrolled in the same section of the subject" do
        duplicate_enrollment = build(:enrollment,
          student: existing_enrollment.student,
          subject: existing_enrollment.subject,
          section: existing_enrollment.section)

        expect(duplicate_enrollment).to be_invalid
        expect(duplicate_enrollment.errors[:student_id]).to include("is already enrolled in this section of the subject")
      end

      it "is valid if student enrolls in a different section of the same subject" do
        new_enrollment = build(:enrollment,
          student: existing_enrollment.student,
          subject: existing_enrollment.subject)

        expect(new_enrollment).to be_valid
      end

      it "is valid if student enrolls in the same section of a different subject" do
        new_enrollment = build(:enrollment,
          student: existing_enrollment.student,
          section: existing_enrollment.section)

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
