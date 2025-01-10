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
end
