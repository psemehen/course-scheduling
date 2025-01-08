class Section < ApplicationRecord
  belongs_to :teacher
  belongs_to :subject
  belongs_to :classroom

  enum :days_of_week, {mon_wed_fri: 1, tue_thu: 2, everyday: 3}

  validates :start_time, :end_time, :duration, :days_of_week, presence: true
  validates :duration, inclusion: {in: [50, 80], message: "must be either 50 or 80 minutes"}
  validate :end_time_after_start_time

  private

  def end_time_after_start_time
    errors.add(:end_time, "must be after the start time") if end_time <= start_time
  end
end
