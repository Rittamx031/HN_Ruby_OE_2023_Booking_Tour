FactoryBot.define do
  factory :tour_category do
    category_name { "example_user" }
    created_at { Time.now }
    updated_at { Time.now }
  end
end
