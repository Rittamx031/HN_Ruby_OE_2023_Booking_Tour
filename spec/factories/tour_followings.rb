FactoryBot.define do
  factory :tour_following do
    user { FactoryBot.create(:user) }
    tour { FactoryBot.create(:tour) }
    created_at { Time.now }
    updated_at { Time.now }
  end
end
