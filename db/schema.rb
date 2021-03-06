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

ActiveRecord::Schema.define(version: 2020_11_11_042609) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "available_hours", force: :cascade do |t|
    t.time "start_time"
    t.time "end_time"
    t.integer "day_of_week"
    t.bigint "equipment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipment_id"], name: "index_available_hours_on_equipment_id"
  end

  create_table "capabilities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "equipment", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "lab_space_id"
    t.text "technical_description"
    t.boolean "hidden", default: false
    t.integer "max_usage"
    t.integer "rest_time"
    t.integer "reservations_count", default: 0
    t.index ["lab_space_id"], name: "index_equipment_on_lab_space_id"
  end

  create_table "equipment_capabilities", force: :cascade do |t|
    t.bigint "capability_id", null: false
    t.bigint "equipment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["capability_id"], name: "index_equipment_capabilities_on_capability_id"
    t.index ["equipment_id"], name: "index_equipment_capabilities_on_equipment_id"
  end

  create_table "equipment_materials", force: :cascade do |t|
    t.bigint "material_id", null: false
    t.bigint "equipment_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["equipment_id"], name: "index_equipment_materials_on_equipment_id"
    t.index ["material_id"], name: "index_equipment_materials_on_material_id"
  end

  create_table "lab_administrations", force: :cascade do |t|
    t.bigint "admin_id"
    t.string "space_type"
    t.bigint "space_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["admin_id"], name: "index_lab_administrations_on_admin_id"
    t.index ["space_type", "space_id"], name: "index_lab_administrations_on_space"
  end

  create_table "lab_spaces", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "hours"
    t.string "location"
    t.string "contact_email"
    t.string "contact_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "lab_id"
    t.string "image"
    t.bigint "user_id"
    t.index ["lab_id"], name: "index_lab_spaces_on_lab_id"
    t.index ["user_id"], name: "index_lab_spaces_on_user_id"
  end

  create_table "labs", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.bigint "user_id"
    t.string "location_link"
    t.index ["user_id"], name: "index_labs_on_user_id"
  end

  create_table "materials", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservations", force: :cascade do |t|
    t.integer "status", default: 0
    t.integer "purpose", default: 0
    t.text "comment"
    t.datetime "start_time"
    t.datetime "end_time"
    t.bigint "equipment_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "help_needed"
    t.index ["equipment_id"], name: "index_reservations_on_equipment_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.string "given_name"
    t.string "last_name"
    t.string "institutional_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "available_hours", "equipment"
  add_foreign_key "equipment", "lab_spaces"
  add_foreign_key "equipment_capabilities", "capabilities"
  add_foreign_key "equipment_capabilities", "equipment"
  add_foreign_key "equipment_materials", "equipment"
  add_foreign_key "equipment_materials", "materials"
  add_foreign_key "lab_administrations", "users", column: "admin_id"
  add_foreign_key "lab_spaces", "labs"
  add_foreign_key "reservations", "equipment"
  add_foreign_key "reservations", "users"
end
