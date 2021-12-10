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

ActiveRecord::Schema.define(version: 2021_12_10_000331) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "app_instances", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "app_id", null: false
    t.uuid "user_id", null: false
    t.json "parameters", default: "{}", null: false
    t.string "public_key", null: false
    t.string "log", default: "", null: false
    t.integer "interval", default: 60, null: false
    t.datetime "last_run", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["app_id"], name: "index_app_instances_on_app_id"
    t.index ["last_run"], name: "index_app_instances_on_last_run"
    t.index ["name"], name: "index_app_instances_on_name"
    t.index ["user_id"], name: "index_app_instances_on_user_id"
  end

  create_table "app_servers", force: :cascade do |t|
    t.string "name", null: false
    t.string "port", null: false
    t.string "public_key", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "public", default: false, null: false
    t.uuid "owner_id", null: false
    t.index ["owner_id"], name: "index_app_servers_on_owner_id"
  end

  create_table "apps", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "source", default: "", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "description", default: "", null: false
    t.string "parameters", default: "", null: false
    t.string "consumes", default: [], null: false, array: true
    t.string "publishes", default: [], null: false, array: true
    t.index ["consumes"], name: "index_apps_on_consumes", using: :gin
    t.index ["publishes"], name: "index_apps_on_publishes", using: :gin
  end

  create_table "broker_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "password", null: false
    t.string "enc_password", null: false
    t.boolean "superuser", default: false, null: false
    t.boolean "enabled", default: false, null: false
    t.uuid "provision_request_id", null: false
    t.bigint "broker_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["broker_id"], name: "index_broker_accounts_on_broker_id"
    t.index ["created_at"], name: "index_broker_accounts_on_created_at"
    t.index ["enabled"], name: "index_broker_accounts_on_enabled"
    t.index ["provision_request_id"], name: "index_broker_accounts_on_provision_request_id"
  end

  create_table "broker_acls", force: :cascade do |t|
    t.uuid "username", null: false
    t.string "topic", null: false
    t.uuid "provision_request_id", null: false
    t.integer "permissions", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_at"], name: "index_broker_acls_on_created_at"
    t.index ["provision_request_id"], name: "index_broker_acls_on_provision_request_id"
    t.index ["topic"], name: "index_broker_acls_on_topic"
    t.index ["username"], name: "index_broker_acls_on_username"
  end

  create_table "brokers", force: :cascade do |t|
    t.string "name", null: false
    t.integer "networks_count", default: 0, null: false
    t.integer "devices_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "secure_port", default: 8883, null: false
    t.integer "insecure_port", default: 1883, null: false
    t.integer "insecure_websocket_port", default: 9001, null: false
    t.integer "secure_websocket_port", default: 8083, null: false
    t.string "ssh_hostname"
    t.string "ssh_username"
    t.string "ssh_key"
    t.string "postgresql_database"
    t.string "postgresql_username"
    t.string "postgresql_password"
    t.index ["name"], name: "index_brokers_on_name", unique: true
  end

  create_table "ddcs", force: :cascade do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.string "reference_url", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "json", default: "", null: false
    t.string "examples", default: "", null: false
    t.index ["name"], name: "index_ddcs_on_name"
  end

  create_table "ddcs_devices", force: :cascade do |t|
    t.uuid "device_id", null: false
    t.bigint "ddc_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ddc_id"], name: "index_ddcs_devices_on_ddc_id"
    t.index ["device_id"], name: "index_ddcs_devices_on_device_id"
  end

  create_table "devices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "friendly_name", default: "", null: false
    t.uuid "provision_request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "public", default: false, null: false
    t.string "manufacturer", default: "", null: false
    t.string "model", default: "", null: false
    t.string "serial_number", default: "", null: false
    t.string "pin", default: "", null: false
    t.index ["provision_request_id"], name: "index_devices_on_provision_request_id"
    t.index ["public"], name: "index_devices_on_public"
  end

  create_table "devices_networks", force: :cascade do |t|
    t.uuid "network_id", null: false
    t.uuid "device_id", null: false
    t.index ["device_id"], name: "index_devices_networks_on_device_id"
    t.index ["network_id"], name: "index_devices_networks_on_network_id"
  end

  create_table "devices_users", id: false, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "device_id", null: false
    t.integer "user_role", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["device_id"], name: "index_devices_users_on_device_id"
    t.index ["user_id"], name: "index_devices_users_on_user_id"
  end

  create_table "network_monitors", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "provision_request_id", null: false
    t.datetime "last_accessed"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "token_id", null: false
    t.index ["last_accessed"], name: "index_network_monitors_on_last_accessed"
    t.index ["provision_request_id"], name: "index_network_monitors_on_provision_request_id"
    t.index ["token_id"], name: "index_network_monitors_on_token_id"
    t.index ["user_id"], name: "index_network_monitors_on_user_id"
  end

  create_table "networks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.integer "count_of_users", default: 0, null: false
    t.integer "device_counter", default: 0, null: false
    t.bigint "broker_id"
    t.uuid "announcer_id"
    t.index ["announcer_id"], name: "index_networks_on_announcer_id"
    t.index ["broker_id"], name: "index_networks_on_broker_id"
    t.index ["name"], name: "index_networks_on_name"
  end

  create_table "networks_users", force: :cascade do |t|
    t.uuid "network_id", null: false
    t.uuid "user_id", null: false
    t.index ["network_id"], name: "index_networks_users_on_network_id"
    t.index ["user_id"], name: "index_networks_users_on_user_id"
  end

  create_table "permissions", force: :cascade do |t|
    t.uuid "device_id", null: false
    t.uuid "network_id", null: false
    t.bigint "ddc_id", null: false
    t.boolean "consumes", null: false
    t.boolean "publishes", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ddc_id"], name: "index_permissions_on_ddc_id"
    t.index ["device_id", "network_id", "ddc_id", "consumes"], name: "index_permissions_consumable"
    t.index ["device_id", "network_id", "ddc_id", "publishes"], name: "index_permissions_publishable"
    t.index ["device_id"], name: "index_permissions_on_device_id"
    t.index ["network_id"], name: "index_permissions_on_network_id"
  end

  create_table "provision_requests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.inet "ip_address", null: false
    t.string "friendly_name", default: "", null: false
    t.integer "status", limit: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "consumes", default: [], null: false, array: true
    t.string "publishes", default: [], null: false, array: true
    t.integer "networks_counter", default: 0, null: false
    t.uuid "network_id"
    t.uuid "user_id", null: false
    t.boolean "ready", default: true, null: false
    t.index ["consumes"], name: "index_provision_requests_on_consumes", using: :gin
    t.index ["friendly_name"], name: "index_provision_requests_on_friendly_name"
    t.index ["network_id"], name: "index_provision_requests_on_network_id"
    t.index ["publishes"], name: "index_provision_requests_on_publishes", using: :gin
    t.index ["ready"], name: "index_provision_requests_on_ready"
    t.index ["user_id"], name: "index_provision_requests_on_user_id"
  end

  create_table "public_devices", force: :cascade do |t|
    t.string "title", null: false
    t.string "description", null: false
    t.uuid "device_id", null: false
    t.boolean "active", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["device_id"], name: "index_public_devices_on_device_id"
  end

  create_table "public_networks", force: :cascade do |t|
    t.string "title", null: false
    t.string "description", null: false
    t.uuid "network_id", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["network_id"], name: "index_public_networks_on_network_id"
  end

  create_table "tokens", id: :string, force: :cascade do |t|
    t.uuid "user_id"
    t.uuid "device_id"
    t.uuid "provision_request_id"
    t.uuid "network_id"
    t.string "name", null: false
    t.string "scope", null: false
    t.boolean "enabled", default: false, null: false
    t.datetime "expires"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["device_id"], name: "index_tokens_on_device_id"
    t.index ["network_id"], name: "index_tokens_on_network_id"
    t.index ["provision_request_id"], name: "index_tokens_on_provision_request_id"
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
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
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.boolean "approved", default: false, null: false
    t.index ["approved"], name: "index_users_on_approved"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "app_instances", "apps"
  add_foreign_key "app_instances", "users"
  add_foreign_key "app_servers", "users", column: "owner_id"
  add_foreign_key "broker_accounts", "brokers"
  add_foreign_key "broker_accounts", "provision_requests"
  add_foreign_key "broker_acls", "provision_requests"
  add_foreign_key "devices", "provision_requests"
  add_foreign_key "network_monitors", "provision_requests"
  add_foreign_key "network_monitors", "tokens"
  add_foreign_key "network_monitors", "users"
  add_foreign_key "permissions", "ddcs"
  add_foreign_key "permissions", "devices"
  add_foreign_key "permissions", "networks"
  add_foreign_key "provision_requests", "users"
  add_foreign_key "public_devices", "devices"
  add_foreign_key "public_networks", "networks"
  add_foreign_key "tokens", "devices"
  add_foreign_key "tokens", "networks"
  add_foreign_key "tokens", "provision_requests"
  add_foreign_key "tokens", "users"
end
