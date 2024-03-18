require "faker"
FactoryBot.define do
  factory :review do
    review_text { "Review text 1" }
    booking { FactoryBot.create(:booking) }
    created_at {Time.zone.now}
    updated_at {Time.zone.now}
  end
end
