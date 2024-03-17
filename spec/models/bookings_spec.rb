require 'rails_helper'

RSpec.describe Booking, type: :model do
  let(:booking_reason){{
    "reason" => "Cancel test"
    }
  }
  describe "#Create Booking " do
    it "Create new booking valid" do
      booking = create(:booking)
      expect(booking.save).to be true
    end

    it "new with date date start before now" do
      booking = build(:booking, date_start: Time.zone.now - 1.day)
      expect(booking.save).to be false
    end

    it "new with over people " do
      booking = create(:booking)
      booking.numbers_people = booking.tour_detail.max_people + 1
      expect(booking.save).to be false
    end
  end

  describe "#cancel_booking" do
    let(:booking) { create(:booking) }

    context "when booking is pending" do
      it "cancels the booking and sends cancel email" do
        expect { booking.cancel_booking booking_reason }.to change { booking.reload.status.to_sym }.to(:canceled)
      end
    end

    context "when booking is not pending" do
      before { booking.confirmed! }

      it "raises an error and does not cancel the booking" do
        expect { booking.cancel_booking booking_reason }.to raise_error(RuntimeError)
        expect(booking.reload.status.to_sym).not_to eq(:canceled)
      end
    end
  end

  describe "#confirm_booking" do
    let(:booking) { create(:booking) }

    context "when booking is pending" do
      it "confirms the booking and sends confirm email" do
        expect { booking.confirm_booking }.to change { booking.reload.status.to_sym }.to(:confirmed)
      end
    end

    context "when booking is not pending" do
      before {
        booking.reason = "TEST"
        booking.canceled!
      }

      it "does not confirm the booking" do
        expect { booking.confirm_booking }.to raise_error(RuntimeError)
        expect(booking.status.to_sym).not_to eq(:confirmed)
      end
    end
  end

  describe "#successed_booking" do
    let(:booking) { create(:booking) }
    it "updates the booking status to successed and sends success email" do
      booking.confirmed!
      expect { booking.successed_booking }.to change { booking.status.to_sym }.to(:successed)
    end
  end
end
