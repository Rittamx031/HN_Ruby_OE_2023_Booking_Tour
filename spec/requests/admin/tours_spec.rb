require 'rails_helper'

RSpec.describe "Admin::Tours", :admin, type: :request do
  before do
    sign_in  FactoryBot.create(:user, admin: true)
  end
  describe "GET /admin/tours" do
    it "works! (now write some real specs)" do
      get admin_tours_path
      expect(response).to have_http_status(200)
    end
  end
end
