class BookingUpdateJob
  include Sidekiq::Worker
  def perform
    Booking.overtimebooking.each do |booking|
      puts "Cancelling booking #{booking.id}"
      begin
        BookingStatusCancelJob.new.perform(booking.id)
        puts "Booking #{booking.id} cancelled successfully"
      rescue StandardError => e
        puts "Error cancelling booking #{booking.id}: #{e.message}"
        # Optionally, you can log the error or take appropriate action
      end
    end
    Booking.successbooking.each do  |booking|
      BookingStatusSuccessJob.new.perform booking.id
    end
  end
end
