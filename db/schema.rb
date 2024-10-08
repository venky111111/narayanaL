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

ActiveRecord::Schema.define(version: 2024_07_09_061035) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "addresses", force: :cascade do |t|
    t.integer "user_id"
    t.string "house_number"
    t.string "street"
    t.string "landmark"
    t.text "direction_to_reach"
    t.string "address_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "otps", force: :cascade do |t|
    t.integer "user_id"
    t.string "otp_number"
    t.datetime "otp_expiry"
    t.string "type"
    t.string "email"
    t.string "mobile_number"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "full_phone_number"
    t.integer "country_code"
    t.bigint "phone_number"
    t.string "email"
    t.boolean "activated", default: false
    t.boolean "email_verified", default: false
    t.boolean "mobile_verified", default: false
    t.string "device_id"
    t.text "unique_auth_id"
    t.string "password_digest"
    t.string "type"
    t.string "username"
    t.boolean "is_blacklisted", default: false
    t.string "platform"
    t.string "gender"
    t.boolean "two_factor_auth", default: false
    t.datetime "suspend_until"
    t.date "date_of_birth"
    t.boolean "whatsapp_communication", default: false
    t.string "full_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "provider"
    t.string "uid"
  end

  create_table "workspaces", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.string "image"
    t.string "sub_title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
