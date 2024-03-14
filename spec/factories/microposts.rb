FactoryBot.define do
    factory :micropost do
      user
      content { Faker::Lorem.paragraph_by_chars(number: 100) }
    end
  end