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

ActiveRecord::Schema[8.0].define(version: 2024_11_15_210223) do
  create_table "calls", force: :cascade do |t|
    t.string "incident_number", null: false
    t.string "call_type", null: false
    t.string "call_type_group", null: false
    t.datetime "call_time", precision: nil, null: false
    t.string "street"
    t.string "call_origin", null: false
    t.boolean "mental_health", default: false
    t.boolean "drug_related", default: false
    t.boolean "dv_related", default: false
    t.boolean "alcohol_related", default: false
    t.string "area", null: false
    t.string "area_name", null: false
    t.decimal "latitude", precision: 10, scale: 6, null: false
    t.decimal "longitude", precision: 10, scale: 6, null: false
    t.string "hour", null: false
    t.string "day_of_week", null: false
    t.integer "ward"
    t.string "district", null: false
    t.string "priority", null: false
    t.string "month", null: false
    t.integer "year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "apco_code"
    t.string "apco_description"
    t.string "apco_notes"
  end
end
