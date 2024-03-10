class BookingStatusCancelJob
  include Sidekiq::Worker

  def perform booking_id
    booking = Booking.find booking_id
    booking.cancel_booking({"reason" => Settings.over_time})
  end
end
