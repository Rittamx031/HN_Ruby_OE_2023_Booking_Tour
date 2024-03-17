require 'rails_helper'

RSpec.describe "Admin::TourDetails", :admin, type: :request do
  before do
    sign_in  FactoryBot.create(:user, admin: true)
  end
  describe "GET /admin/tour_details" do
  end
end
