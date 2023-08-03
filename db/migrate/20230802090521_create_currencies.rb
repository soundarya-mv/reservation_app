class CreateCurrencies < ActiveRecord::Migration[7.0]
  def change
    create_table "Currencies", force: :cascade do |t|
      t.string "currency"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
    end
  end
end
