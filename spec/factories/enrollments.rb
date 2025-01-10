FactoryBot.define do
  factory :enrollment do
    association :student
    association :subject
    association :section
  end
end
