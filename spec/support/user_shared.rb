require "rails_helper"

RSpec.shared_context "shared user login controller" do
  let(:user){create(:user)}

  before do
    sign_in user
  end
end
