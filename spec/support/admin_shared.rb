require "rails_helper"

RSpec.shared_context "shared admin controller" do
  let(:admin){create(:admin)}

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(admin)
  end
end

RSpec.configure do |config|
  config.include_context "shared admin controller", :admin
end
