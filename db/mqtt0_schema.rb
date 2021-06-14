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

ActiveRecord::Schema.define(version: 2020_09_30_060413) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "mosquitto_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "password", null: false
    t.boolean "superuser", default: false, null: false
    t.uuid "provision_request_id", null: false
    t.boolean "enabled", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_at"], name: "index_mosquitto_accounts_on_created_at"
    t.index ["enabled", "provision_request_id"], name: "index_mosquitto_accounts_on_enabled_and_provision_request_id", unique: true
    t.index ["id", "enabled"], name: "index_mosquitto_accounts_on_id_and_enabled"
    t.index ["provision_request_id"], name: "index_mosquitto_accounts_on_provision_request_id", unique: true
  end

  create_table "mosquitto_acls", force: :cascade do |t|
    t.uuid "username", null: false
    t.string "topic", null: false
    t.uuid "provision_request_id", null: false
    t.integer "permissions", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["provision_request_id"], name: "index_mosquitto_acls_on_provision_request_id"
    t.index ["topic"], name: "index_mosquitto_acls_on_topic"
    t.index ["username"], name: "index_mosquitto_acls_on_username"
  end

end
