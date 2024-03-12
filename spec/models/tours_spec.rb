require 'rails_helper'

RSpec.describe Tour, type: :model do
  it "Create new tour " do
    tour = FactoryBot.create(:tour)
    expect(tour.save).to be true
  end
end
