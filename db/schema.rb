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

ActiveRecord::Schema.define(version: 2020_10_01_033502) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "brokers", force: :cascade do |t|
    t.string "name", null: false
    t.integer "networks_count", default: 0, null: false
    t.integer "devices_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "secure_port", default: 1883, null: false
    t.integer "insecure_port", default: 8883, null: false
    t.index ["name"], name: "index_brokers_on_name", unique: true
  end

  create_table "devices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "friendly_name", default: "", null: false
    t.uuid "provision_request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "calibrated", default: false, null: false
    t.index ["provision_request_id"], name: "index_devices_on_provision_request_id"
  end

  create_table "devices_networks", force: :cascade do |t|
    t.bigint "network_id"
    t.uuid "device_id"
    t.index ["device_id"], name: "index_devices_networks_on_device_id"
    t.index ["network_id"], name: "index_devices_networks_on_network_id"
  end

  create_table "devices_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.uuid "device_id", null: false
    t.integer "user_role", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["device_id"], name: "index_devices_users_on_device_id"
    t.index ["user_id"], name: "index_devices_users_on_user_id"
  end

  create_table "mosquitto_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "password", null: false
    t.boolean "superuser", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "provision_request_id"
    t.boolean "enabled", default: true, null: false
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

  create_table "networks", force: :cascade do |t|
    t.string "name", null: false
    t.integer "count_of_users", default: 0, null: false
    t.integer "device_counter", default: 0, null: false
    t.bigint "broker_id"
    t.index ["broker_id"], name: "index_networks_on_broker_id"
    t.index ["name"], name: "index_networks_on_name"
  end

  create_table "networks_users", force: :cascade do |t|
    t.bigint "network_id"
    t.bigint "user_id"
    t.index ["network_id"], name: "index_networks_users_on_network_id"
    t.index ["user_id"], name: "index_networks_users_on_user_id"
  end

  create_table "provision_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "pin", default: "", null: false
    t.inet "ip_address", null: false
    t.string "friendly_name", default: "", null: false
    t.string "manufacturer", default: "", null: false
    t.string "model", default: "", null: false
    t.string "serial_number", default: "", null: false
    t.integer "status", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ro_ddcs", default: [], null: false, array: true
    t.string "wo_ddcs", default: [], null: false, array: true
    t.string "rw_ddcs", default: [], null: false, array: true
    t.uuid "allocated_uuids", default: [], null: false, array: true
    t.integer "requested_uuid_count", default: 1, null: false
    t.integer "networks_counter", default: 0, null: false
    t.bigint "network_id"
    t.index ["allocated_uuids"], name: "index_provision_requests_on_allocated_uuids", using: :gin
    t.index ["friendly_name"], name: "index_provision_requests_on_friendly_name"
    t.index ["manufacturer"], name: "index_provision_requests_on_manufacturer"
    t.index ["model"], name: "index_provision_requests_on_model"
    t.index ["network_id"], name: "index_provision_requests_on_network_id"
    t.index ["ro_ddcs"], name: "index_provision_requests_on_ro_ddcs", using: :gin
    t.index ["rw_ddcs"], name: "index_provision_requests_on_rw_ddcs", using: :gin
    t.index ["wo_ddcs"], name: "index_provision_requests_on_wo_ddcs", using: :gin
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "networks_count", default: 0, null: false
    t.string "name", default: "", null: false
    t.boolean "site_admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "devices", "provision_requests"
end
