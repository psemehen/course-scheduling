FactoryBot.define do
  factory :classroom do
    sequence(:name) { |n| "Room #{n}" }
    capacity { 40 }
  end
end
