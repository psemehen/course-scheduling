FactoryBot.define do
  factory :student do
    first_name { "Test" }
    sequence(:last_name) { |n| "Student#{n}" }
    sequence(:email) { |n| "student#{n}@gmail.com" }
  end
end
