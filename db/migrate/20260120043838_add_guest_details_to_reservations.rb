class AddGuestDetailsToReservations < ActiveRecord::Migration[8.0]
  def change
    add_column :reservations, :guest_count, :integer
    add_column :reservations, :phone_number, :string
  end
end
