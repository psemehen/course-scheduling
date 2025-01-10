FactoryBot.define do
  factory :teacher do
    first_name { "Test" }
    sequence(:last_name) { |n| "Teacher#{n}" }
    sequence(:email) { |n| "teacher#{n}@gmail.com" }
  end
end
