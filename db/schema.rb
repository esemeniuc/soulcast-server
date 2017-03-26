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

ActiveRecord::Schema.define(version: 20170326210509) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blocks", force: :cascade do |t|
    t.string   "blocker_token"
    t.string   "blockee_token"
    t.integer  "blocker_id"
    t.integer  "blockee_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["blockee_id"], name: "index_blocks_on_blockee_id", using: :btree
    t.index ["blocker_id", "blockee_id"], name: "index_blocks_on_blocker_id_and_blockee_id", unique: true, using: :btree
    t.index ["blocker_id"], name: "index_blocks_on_blocker_id", using: :btree
  end

  create_table "devices", force: :cascade do |t|
    t.string   "token"
    t.float    "latitude"
    t.float    "longitude"
    t.float    "radius"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_devices_on_token", unique: true, using: :btree
  end

  create_table "histories", force: :cascade do |t|
    t.integer  "soul_id"
    t.integer  "device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_histories_on_device_id", using: :btree
    t.index ["soul_id"], name: "index_histories_on_soul_id", using: :btree
  end

  create_table "improves", force: :cascade do |t|
    t.string   "soulType"
    t.string   "s3Key"
    t.integer  "epoch"
    t.float    "latitude"
    t.float    "longitude"
    t.float    "radius"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rpush_apps", force: :cascade do |t|
    t.string   "name",                                null: false
    t.string   "environment"
    t.text     "certificate"
    t.string   "password"
    t.integer  "connections",             default: 1, null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "type",                                null: false
    t.string   "auth_key"
    t.string   "client_id"
    t.string   "client_secret"
    t.string   "access_token"
    t.datetime "access_token_expiration"
  end

  create_table "rpush_feedback", force: :cascade do |t|
    t.string   "device_token", limit: 64, null: false
    t.datetime "failed_at",               null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "app_id"
    t.index ["device_token"], name: "index_rpush_feedback_on_device_token", using: :btree
  end

  create_table "rpush_notifications", force: :cascade do |t|
    t.integer  "badge"
    t.string   "device_token",      limit: 64
    t.string   "sound",                        default: "default"
    t.text     "alert"
    t.text     "data"
    t.integer  "expiry",                       default: 86400
    t.boolean  "delivered",                    default: false,     null: false
    t.datetime "delivered_at"
    t.boolean  "failed",                       default: false,     null: false
    t.datetime "failed_at"
    t.integer  "error_code"
    t.text     "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.boolean  "alert_is_json",                default: false
    t.string   "type",                                             null: false
    t.string   "collapse_key"
    t.boolean  "delay_while_idle",             default: false,     null: false
    t.text     "registration_ids"
    t.integer  "app_id",                                           null: false
    t.integer  "retries",                      default: 0
    t.string   "uri"
    t.datetime "fail_after"
    t.boolean  "processing",                   default: false,     null: false
    t.integer  "priority"
    t.text     "url_args"
    t.string   "category"
    t.boolean  "content_available",            default: false
    t.text     "notification"
    t.index ["delivered", "failed"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))", using: :btree
  end

  create_table "souls", force: :cascade do |t|
    t.string   "soulType"
    t.string   "s3Key"
    t.integer  "epoch"
    t.float    "latitude"
    t.float    "longitude"
    t.float    "radius"
    t.string   "token"
    t.integer  "device_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["device_id"], name: "index_souls_on_device_id", using: :btree
  end

  create_table "souls_evils", force: :cascade do |t|
    t.string   "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "histories", "devices"
  add_foreign_key "histories", "souls"
  add_foreign_key "souls", "devices"
end
