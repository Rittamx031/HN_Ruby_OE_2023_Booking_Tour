require 'rails_helper'

RSpec.describe TourDetail, type: :model do
  it "Create new tour details " do
    tour_detail = FactoryBot.create(:tour_detail)
    expect(tour_detail.save).to be true
  end
end
