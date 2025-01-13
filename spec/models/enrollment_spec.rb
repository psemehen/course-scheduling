require "rails_helper"

RSpec.describe Enrollment, type: :model do
  describe "validations" do
    describe "uniqueness validation" do
      let(:student) { create(:student) }
      let(:subject) { create(:subject) }
      let(:section) { create(:section) }
      let!(:existing_enrollment) { create(:enrollment, student: student, subject: subject, section: section) }

      context "when enrolling in the same section of the same subject" do
        let(:duplicate_enrollment) { build(:enrollment, student: student, subject: subject, section: section) }

        it "is invalid" do
          expect(duplicate_enrollment).to be_invalid
          expect(duplicate_enrollment.errors[:student_id])
            .to include("is already enrolled in this section of the subject")
        end
      end

      context "when enrolling in a different section of the same subject" do
        let(:new_section) { create(:section, :afternoon_section) }
        let(:new_enrollment) { build(:enrollment, student: student, subject: subject, section: new_section) }

        it "is valid" do
          expect(new_enrollment).to be_valid
        end
      end

      context "when enrolling in the same section of a different subject" do
        let(:different_subject) { create(:subject) }
        let(:non_overlapping_section) { create(:section, :afternoon_section) }
        let!(:existing_enrollment) { create(:enrollment, student: student, subject: subject, section: section) }
        let(:new_enrollment) {
          build(:enrollment, student: student, subject: different_subject,
            section: non_overlapping_section)
        }

        it "is valid" do
          expect(new_enrollment).to be_valid
        end
      end

      context "when a different student enrolls in the same section of the subject" do
        let(:different_student) { create(:student) }
        let(:new_enrollment) { build(:enrollment, student: different_student, subject: subject, section: section) }

        it "is valid" do
          expect(new_enrollment).to be_valid
        end
      end
    end

    describe ".no_schedule_overlap" do
      let(:student) { create(:student) }
      let(:subject1) { create(:subject) }
      let(:subject2) { create(:subject) }
      let!(:existing_enrollment) {
        create(:enrollment, student: student, subject: subject1,
          section: overlapping_section1)
      }
      let(:new_enrollment) { build(:enrollment, student: student, subject: subject2, section: overlapping_section2) }

      shared_examples "schedule overlaps" do
        it "is invalid" do
          expect(new_enrollment).to be_invalid
          expect(new_enrollment.errors[:base]).to include(a_string_matching(/overlaps with/))
        end
      end

      context "when there is a schedule overlap based on start time" do
        let(:overlapping_section1) {
          create(:section, start_time: "10:00", end_time: "11:20",
            days_of_week: :mon_wed_fri)
        }
        let(:overlapping_section2) {
          create(:section, start_time: "10:30", end_time: "11:50",
            days_of_week: :mon_wed_fri)
        }

        it_behaves_like "schedule overlaps"
      end

      context "when there is a schedule overlap based on end time" do
        let(:overlapping_section1) {
          create(:section, start_time: "10:00", end_time: "11:20",
            days_of_week: :mon_wed_fri)
        }
        let(:overlapping_section2) {
          create(:section, start_time: "09:30", end_time: "10:50",
            days_of_week: :mon_wed_fri)
        }

        it_behaves_like "schedule overlaps"
      end

      context "when there is a schedule overlap based on start and end times" do
        let(:overlapping_section1) {
          create(:section, start_time: "10:00", end_time: "11:20",
            days_of_week: :mon_wed_fri)
        }
        let(:overlapping_section2) {
          create(:section, start_time: "10:10", end_time: "11:00",
            days_of_week: :mon_wed_fri)
        }

        it_behaves_like "schedule overlaps"
      end

      context "when there is no schedule overlap" do
        let(:non_overlapping_section1) {
          create(:section, start_time: "10:00", end_time: "11:00",
            days_of_week: :mon_wed_fri)
        }
        let(:non_overlapping_section2) { create(:section, :afternoon_section) }
        let!(:existing_enrollment) {
          create(:enrollment, student: student, subject: subject1,
            section: non_overlapping_section1)
        }
        let(:new_enrollment) {
          build(:enrollment, student: student, subject: subject2,
            section: non_overlapping_section2)
        }

        it "is valid" do
          expect(new_enrollment).to be_valid
        end
      end

      context "when sections are on different days" do
        let(:mwf_section) { create(:section, days_of_week: :mon_wed_fri) }
        let(:tth_section) { create(:section, :tue_thu_section) }
        let!(:existing_enrollment) { create(:enrollment, student: student, subject: subject1, section: mwf_section) }
        let(:new_enrollment) { build(:enrollment, student: student, subject: subject2, section: tth_section) }

        it "is valid" do
          expect(new_enrollment).to be_valid
        end
      end
    end
  end
end
