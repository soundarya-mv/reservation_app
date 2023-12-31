# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_08_02_090521) do
  create_table "Currencies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "Guest_contact_numbers", force: :cascade do |t|
    t.integer "guest_id"
    t.integer "contact_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "Guests", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "Reservations", force: :cascade do |t|
    t.integer "guest_id"
    t.string "code"
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "adults", default: 0
    t.integer "children", default: 0
    t.integer "infants", default: 0
    t.integer "status"
    t.integer "currency_id", default: 0
    t.float "payout_price"
    t.float "security_price"
    t.float "total_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
