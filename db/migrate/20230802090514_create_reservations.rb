class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table "Reservations", force: :cascade do |t|
      t.integer "guest_id"
      t.integer "reservation_code", null: false
      t.datetime "start_date", null: false
      t.datetime "end_date", null: false
      t.integer "adults", default: 0
      t.integer "children", default: 0
      t.integer "infants", default: 0
      t.boolean "status", default: 0
      t.integer "currency_id", default: 0
      t.float "payout_price"
      t.float "security_price"
      t.float "total_price"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
