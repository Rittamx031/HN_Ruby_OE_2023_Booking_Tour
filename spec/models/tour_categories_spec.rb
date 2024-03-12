require 'rails_helper'

RSpec.describe TourCategory, type: :model do
  it "Create new tour category " do
    tour_category = FactoryBot.create(:tour_category)
    expect(tour_category.save).to be true
  end
end
