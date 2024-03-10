class BookingStatusSuccessJob
  include Sidekiq::Worker

  def perform booking_id
    booking = Booking.find booking_id
    booking.successed_booking
  end
end
