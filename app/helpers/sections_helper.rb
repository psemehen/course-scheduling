module SectionsHelper
  def days_of_week_options
    Section.days_of_weeks.map do |key, value|
      [days_of_week_display(key), key]
    end
  end

  def days_of_week_display(days_of_week)
    days_of_week.to_s.titleize.tr("_", " ")
  end
end
