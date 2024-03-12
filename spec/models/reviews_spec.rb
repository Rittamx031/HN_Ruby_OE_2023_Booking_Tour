require 'rails_helper'

RSpec.describe Review, type: :model do
  it "Create new review " do
    review = FactoryBot.create(:review)
    expect(review.save).to be true
  end
end
