require 'support/admin_shared'

RSpec.describe Admin::BillsController, :admin, type: :controller do
  let(:booking) { create(:booking) }

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #cancel_modal" do
    it "returns a success response" do
      get :cancel_modal, as: :turbo_stream, params: { id: booking.id }
      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq Mime[:turbo_stream]
    end
  end

  describe "POST #submit_cancel" do
    context "with valid params" do
      it "cancels the booking" do
        post :submit_cancel, as: :turbo_stream, params: { id: booking.id, booking: { reason: "TEST" } }
        expect(response).to have_http_status(:ok)
        expect(response.media_type).to eq Mime[:turbo_stream]
      end
    end

    context "with invalid params" do
      it "renders the new template" do
        post :submit_cancel, as: :turbo_stream, params: { id: booking.id, booking: { reason: "" } }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.media_type).to eq Mime[:turbo_stream]
      end
    end
  end

  describe "PATCH #confirm" do
    it "confirms the booking" do
      patch :confirm, as: :turbo_stream, params: { id: booking.id }
      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq Mime[:turbo_stream]
    end
  end
end
