class CreateGuestContactNumbers < ActiveRecord::Migration[7.0]
  def change
    create_table "Guest_contact_numbers", force: :cascade do |t|
      t.integer "guest_id"
      t.integer "contact_number"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
