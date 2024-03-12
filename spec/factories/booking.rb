require "faker"
FactoryBot.define do
  factory :booking do
    booking_date { Time.zone.now}
    phone { "84367673799" }
    date_start { Time.zone.now + 3.days }
    numbers_people { 3 }
    tour_detail { FactoryBot.create(:tour_detail) }
    user { FactoryBot.create(:user) }
    created_at {Time.zone.now}
    updated_at {Time.zone.now}
  end
end
