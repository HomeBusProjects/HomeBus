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

ActiveRecord::Schema.define(version: 2018_06_19_145306) do

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

  create_table "devices_and_spaces", id: false, force: :cascade do |t|
    t.uuid "device_id"
    t.uuid "space_id"
    t.index ["device_id"], name: "index_devices_and_spaces_on_device_id"
    t.index ["space_id"], name: "index_devices_and_spaces_on_space_id"
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
    t.boolean "rw", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "provision_request_id"
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

  create_table "spaces", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "friendly_name"
    t.boolean "interior"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "devices", "provision_requests"
end
