FactoryBot.define do
  factory :micropost do
    user
    content { Faker::Lorem.paragraph_by_chars(number: 100) }
    created_at { 10.minutes.ago }
  end
end
