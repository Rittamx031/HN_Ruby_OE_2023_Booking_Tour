require 'rails_helper'

RSpec.describe TourFollowing, type: :model do
  it "Create new tour following " do
    tour_following = FactoryBot.create(:tour_following)
    expect(tour_following.save).to be true
  end
end
