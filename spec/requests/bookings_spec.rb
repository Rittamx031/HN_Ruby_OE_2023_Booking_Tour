require "support/user_shared"

RSpec.describe BookingsController, type: :controller do
  include_context "shared user login controller"
  describe "GET #new" do
    it "returns a successful response" do
        tour_detail = create(:tour_detail)
        get :new ,  params: { id: tour_detail.id }
        should render_template :new
      end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new booking" do
        tour_detail = create(:tour_detail)
        valid_params = { booking: attributes_for(:booking , user_id: user.id, tour_detail_id: tour_detail.id )}
        expect {
          post :create , params: valid_params
        }.to change(Booking, :count).by(1)

        expect(response).to redirect_to(root_path)
      end
    end

    context "with invalid parameters" do
      it "does not create a new booking" do
        invalid_params = { booking: attributes_for(:booking, tour_detail_id: nil, user_id: nil, numbers_people: nil ) }

        expect {
          post :create, params: invalid_params
        }.to_not change(Booking, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        should render_template :new
      end
    end
  end

  describe "PATCH #cancel" do
    let(:booking) { create(:booking, user: user) }
    let(:booking_not_user) { create(:booking, user: create(:user) ) }

    context "when user is the owner of the booking" do
      it "cancels the booking" do
        patch :cancel, params: {id: booking.id}
        expect(response).to redirect_to(history_url)
      end
    end

    context "when user is not the owner of the booking" do
      it "does not cancel the booking" do
        patch :cancel, params: {id: booking_not_user.id}
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #show" do
    let(:booking) { create(:booking) }

    it "returns a successful response" do
      get :show, params: {id: booking.id}
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #booking_history" do
    it "returns a successful response" do
      get :booking_history
      expect(response).to have_http_status(:success)
    end
  end
end
