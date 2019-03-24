# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_03_24_210722) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "account_id", null: false
    t.bigint "role_id", null: false
    t.datetime "deleted_at"
    t.datetime "expires_at"
    t.index ["account_id", "role_id"], name: "index_account_roles_on_account_id_and_role_id", unique: true
    t.index ["account_id"], name: "index_account_roles_on_account_id"
    t.index ["role_id"], name: "index_account_roles_on_role_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "guest_token", null: false
    t.bigint "person_id"
    t.string "nickname", null: false
    t.text "biography"
    t.string "public_name"
    t.index ["person_id"], name: "index_accounts_on_person_id", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "country_states", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "english_name", null: false
    t.string "native_name", null: false
    t.index ["english_name"], name: "index_country_states_on_english_name", unique: true
    t.index ["name"], name: "index_country_states_on_name", unique: true
    t.index ["native_name"], name: "index_country_states_on_native_name", unique: true
  end

  create_table "membership_apps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "middle_name"
    t.date "date_of_birth", null: false
    t.string "occupation"
    t.string "email", null: false
    t.string "phone_number", null: false
    t.string "telegram_username"
    t.text "organization_membership"
    t.text "comment"
    t.bigint "country_state_id"
    t.bigint "account_id", null: false
    t.index ["account_id"], name: "index_membership_apps_on_account_id", unique: true
    t.index ["country_state_id"], name: "index_membership_apps_on_country_state_id"
  end

  create_table "passport_confirmations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "passport_id", null: false
    t.bigint "account_id", null: false
    t.index ["account_id"], name: "index_passport_confirmations_on_account_id"
    t.index ["passport_id", "account_id"], name: "index_passport_confirmations_on_passport_id_and_account_id", unique: true
    t.index ["passport_id"], name: "index_passport_confirmations_on_passport_id"
  end

  create_table "passport_maps", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "surname", null: false
    t.string "given_name", null: false
    t.string "patronymic"
    t.integer "sex", null: false
    t.date "date_of_birth", null: false
    t.string "place_of_birth", null: false
    t.integer "series", null: false
    t.integer "number", null: false
    t.text "issued_by", null: false
    t.string "unit_code", null: false
    t.date "date_of_issue", null: false
    t.bigint "passport_id", null: false
    t.index ["passport_id"], name: "index_passport_maps_on_passport_id"
  end

  create_table "passports", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "confirmed", default: false, null: false
    t.bigint "person_id"
    t.index ["person_id"], name: "index_passports_on_person_id"
  end

  create_table "people", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "regional_office_id"
    t.date "supporter_since"
    t.date "member_since"
    t.date "excluded_since"
    t.index ["regional_office_id"], name: "index_people_on_regional_office_id"
  end

  create_table "regional_offices", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "country_state_id", null: false
    t.index ["country_state_id"], name: "index_regional_offices_on_country_state_id", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "resource_type"
    t.bigint "resource_id"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", unique: true
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "user_omniauths", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.string "provider", null: false
    t.string "remote_id", null: false
    t.string "email", null: false
    t.index ["remote_id", "provider"], name: "index_user_omniauths_on_remote_id_and_provider", unique: true
    t.index ["user_id"], name: "index_user_omniauths_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.bigint "account_id", null: false
    t.index ["account_id"], name: "index_users_on_account_id", unique: true
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "account_roles", "accounts"
  add_foreign_key "account_roles", "roles"
  add_foreign_key "accounts", "people"
  add_foreign_key "membership_apps", "accounts"
  add_foreign_key "membership_apps", "country_states"
  add_foreign_key "passport_confirmations", "accounts"
  add_foreign_key "passport_confirmations", "passports"
  add_foreign_key "passport_maps", "passports"
  add_foreign_key "passports", "people"
  add_foreign_key "people", "regional_offices"
  add_foreign_key "regional_offices", "country_states"
  add_foreign_key "user_omniauths", "users"
  add_foreign_key "users", "accounts"
end
