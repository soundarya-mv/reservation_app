class CreateGuests < ActiveRecord::Migration[7.0]
  def change
    create_table "Guests", force: :cascade do |t|
      t.string "first_name"
      t.string "last_name"
      t.string "email"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
