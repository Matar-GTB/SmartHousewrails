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

ActiveRecord::Schema[8.0].define(version: 2025_04_13_202936) do
  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
  end

  create_table "devices", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deletion_requested", default: false
    t.boolean "status", default: true
    t.string "location"
    t.integer "category_id"
    t.index ["category_id"], name: "index_devices_on_category_id"
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "smart_services", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "user_id", null: false
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_smart_services_on_category_id"
    t.index ["user_id"], name: "index_smart_services_on_user_id"
  end

# Could not dump table "users" because of following StandardError
#   Unknown type 'inet' for column 'current_sign_in_ip'


  add_foreign_key "devices", "categories"
  add_foreign_key "devices", "users"
  add_foreign_key "smart_services", "categories"
  add_foreign_key "smart_services", "users"
end
