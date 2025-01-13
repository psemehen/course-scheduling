require "rails_helper"

RSpec.describe Section, type: :model do
  describe "validations" do
    let(:section) { build(:section) }

    describe "end_time_after_start_time" do
      it "is valid when end_time is after start_time" do
        expect(section).to be_valid
      end

      it "is invalid when end_time is before start_time" do
        section.end_time = section.start_time - 1.hour

        expect(section).to be_invalid
        expect(section.errors[:end_time]).to include("must be after the start time")
      end

      it "is invalid when end_time is equal to start_time" do
        section.end_time = section.start_time

        expect(section).to be_invalid
        expect(section.errors[:end_time]).to include("must be after the start time")
      end
    end

    describe "validate_start_time" do
      it "is valid when start_time is at 7:30 AM" do
        section.start_time = Time.zone.parse("07:30")

        expect(section).to be_valid
      end

      it "is invalid when start_time is before 7:30 AM" do
        section.start_time = Time.zone.parse("07:29")

        expect(section).to be_invalid
        expect(section.errors[:start_time]).to include("must be no earlier than 7:30 AM")
      end
    end

    describe "validate_end_time" do
      it "is valid when end_time is at 10:00 PM" do
        section.end_time = Time.zone.parse("2025-06-01 22:00:00")

        expect(section).to be_valid
      end

      it "is invalid when end_time is after 10:00 PM" do
        section.end_time = Time.zone.parse("22:50")

        expect(section).to be_invalid
        expect(section.errors[:end_time]).to include("must be no later than 10:00 PM")
      end
    end
  end

  describe "scopes" do
    let(:teacher) { create(:teacher) }
    let(:subject) { create(:subject) }
    let(:classroom) { create(:classroom) }

    describe ".overlapping_sections" do
      let!(:section1) { create(:section, start_time: "09:00", end_time: "10:00", days_of_week: :mon_wed_fri, teacher: teacher, subject: subject, classroom: classroom) }
      let!(:section2) { create(:section, start_time: "09:30", end_time: "10:30", days_of_week: :mon_wed_fri, teacher: teacher, subject: subject, classroom: classroom) }
      let!(:section3) { create(:section, start_time: "10:30", end_time: "11:30", days_of_week: :mon_wed_fri, teacher: teacher, subject: subject, classroom: classroom) }
      let!(:section4) { create(:section, start_time: "09:00", end_time: "10:00", days_of_week: :tue_thu, teacher: teacher, subject: subject, classroom: classroom) }

      it "returns overlapping sections" do
        expect(Section.overlapping_sections(section1)).to include(section2)
        expect(Section.overlapping_sections(section1)).not_to include(section3, section4)
      end
    end

    describe ".overlapping_days_of_week" do
      let!(:everyday_section) { create(:section, days_of_week: :everyday, teacher: teacher, subject: subject, classroom: classroom) }
      let!(:mwf_section) { create(:section, days_of_week: :mon_wed_fri, teacher: teacher, subject: subject, classroom: classroom) }
      let!(:tth_section) { create(:section, days_of_week: :tue_thu, teacher: teacher, subject: subject, classroom: classroom) }

      it "returns sections with overlapping days" do
        expect(Section.overlapping_days_of_week(mwf_section)).to include(everyday_section, mwf_section)
        expect(Section.overlapping_days_of_week(mwf_section)).not_to include(tth_section)
      end

      it "returns all sections for everyday sections" do
        expect(Section.overlapping_days_of_week(everyday_section)).to include(everyday_section, mwf_section, tth_section)
      end
    end

    describe ".overlapping_time" do
      let!(:section1) { create(:section, start_time: "09:00", end_time: "10:00", teacher: teacher, subject: subject, classroom: classroom) }
      let!(:section2) { create(:section, start_time: "09:30", end_time: "10:30", teacher: teacher, subject: subject, classroom: classroom) }
      let!(:section3) { create(:section, start_time: "10:30", end_time: "11:30", teacher: teacher, subject: subject, classroom: classroom) }

      it "returns sections with overlapping times" do
        expect(Section.overlapping_time(section1)).to include(section2)
        expect(Section.overlapping_time(section1)).not_to include(section3)
      end
    end
  end
end
