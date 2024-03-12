require 'support/admin_shared'

RSpec.describe "Admin::Bills", type: :request do
  before do
    sign_in FactoryBot.create(:user, admin: true)
  end
  describe "GET /admin/bills" do
    it "works! (now write some real specs)" do
      get admin_bills_path
      expect(response).to have_http_status(200)
    end
  end
end
