set :output, "./log/cron.log"

every 1.day, at: '0:00 am' do
  runner "BookingUpdateJob.new.perform"
end
