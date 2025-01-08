class Section < ApplicationRecord
  belongs_to :teacher
  belongs_to :subject
  belongs_to :classroom

  enum :days_of_week, {mon_wed_fri: 1, tue_thu: 2, everyday: 3}

  validates :start_time, :end_time, :duration, :days_of_week, presence: true
  validates :duration, inclusion: {in: [50, 80], message: "must be either 50 or 80 minutes"}
  validate :validate_start_time
  validate :validate_end_time
  validate :end_time_after_start_time

  private

  def end_time_after_start_time
    errors.add(:end_time, "must be after the start time") if end_time <= start_time
  end

  def validate_start_time
    errors.add(:start_time, "must be no earlier than 7:30 AM") if start_time.strftime("%H:%M") < "07:30"
  end

  def validate_end_time
    errors.add(:end_time, "must be no later than 10:00 PM") if end_time.strftime("%H:%M") > "22:00"
  end
end
