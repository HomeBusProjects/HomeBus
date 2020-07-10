# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_07_10_171759) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "devices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "provisioned", default: false, null: false
    t.string "friendly_name", default: "", null: false
    t.string "friendly_location", default: "", null: false
    t.integer "accuracy", null: false
    t.integer "precision", null: false
    t.integer "update_frequency", null: false
    t.string "wo_topics", default: [], array: true
    t.string "ro_topics", default: [], array: true
    t.string "rw_topics", default: [], array: true
    t.uuid "provision_request_id"
    t.string "index", default: "0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "calibrated", default: false, null: false
    t.index ["provision_request_id"], name: "index_devices_on_provision_request_id"
  end

  create_table "mosquitto_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "password", null: false
    t.boolean "superuser", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "provision_request_id"
    t.index ["provision_request_id"], name: "index_mosquitto_accounts_on_provision_request_id"
  end

  create_table "mosquitto_acls", force: :cascade do |t|
    t.string "username", null: false
    t.string "topic", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "provision_request_id"
    t.integer "permissions", default: 0, null: false
    t.index ["provision_request_id"], name: "index_mosquitto_acls_on_provision_request_id"
    t.index ["username"], name: "index_mosquitto_acls_on_username"
  end

  create_table "provision_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "pin", default: "", null: false
    t.inet "ip_address", null: false
    t.string "friendly_name", default: "", null: false
    t.string "friendly_location", default: "", null: false
    t.string "manufacturer", default: "", null: false
    t.string "model", default: "", null: false
    t.string "serial_number", default: "", null: false
    t.integer "status", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friendly_name"], name: "index_provision_requests_on_friendly_name"
    t.index ["manufacturer"], name: "index_provision_requests_on_manufacturer"
    t.index ["model"], name: "index_provision_requests_on_model"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "devices", "provision_requests"
end
