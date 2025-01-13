FactoryBot.define do
  factory :section do
    start_time { Time.zone.parse("2025-06-01 09:00:00") }
    end_time { Time.zone.parse("2025-06-01 09:50:00") }
    duration { 50 }
    days_of_week { :mon_wed_fri }
    association :teacher
    association :subject
    association :classroom

    trait :tue_thu_section do
      days_of_week { :tue_thu }
    end

    trait :everyday_section do
      days_of_week { :everyday }
    end

    trait :afternoon_section do
      start_time { Time.zone.parse("2025-06-01 13:00:00") }
      end_time { Time.zone.parse("2025-06-01 13:50:00") }
    end

    trait :evening_section do
      start_time { Time.zone.parse("2025-06-01 18:00:00") }
      end_time { Time.zone.parse("2025-06-01 18:50:00") }
    end
  end
end
