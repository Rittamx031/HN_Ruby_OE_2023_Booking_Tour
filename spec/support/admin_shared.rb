require "rails_helper"

RSpec.shared_context "shared admin controller" do
  let(:admin){create(:admin)}

  before do
    sign_in admin
  end
end

RSpec.configure do |config|
  config.include_context "shared admin controller", :admin
end
