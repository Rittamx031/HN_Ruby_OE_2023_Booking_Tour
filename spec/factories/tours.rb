require "faker"
FactoryBot.define do
  factory :tour do
    tour_name { "Tour Example 1" }
    hagtag { "#HCM#HN" }
    tour_description { "<h1>CC</h1>" }
    created_at { Time.now }
    updated_at { Time.now }
    tour_category { FactoryBot.create(:tour_category) }
    after(:build) do |tour|
      image = URI.open(Faker::LoremFlickr.pixelated_image)
      tour.image.attach(io: image, filename: 'image.jpg', content_type: 'image/jpeg')
    end
  end
end
