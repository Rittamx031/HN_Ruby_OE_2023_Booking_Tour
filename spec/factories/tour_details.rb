FactoryBot.define do
  factory :tour_detail do
    tour_detail_name { "Tour Details Example 1" }
    max_people { 20 }
    start_location { "Hà Nội"}
    time_duration { 2 }
    price { 20000 }
    detail_description { "<h1>CC</h1>" }
    created_at { Time.now }
    updated_at { Time.now }
    tour { FactoryBot.create(:tour) }
  end
end
