class AddCccdToBooking < ActiveRecord::Migration[7.0]
  def change
    add_column :bookings, :cccd, :string
  end
end
