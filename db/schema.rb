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

ActiveRecord::Schema.define(version: 20161119231633) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "blocks", force: :cascade do |t|
    t.string   "token"
    t.string   "blockedToken"
    t.integer  "device_id"
    t.integer  "blocked_device_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["device_id"], name: "index_blocks_on_device_id", using: :btree
    t.index ["token", "blockedToken"], name: "index_blocks_on_token_and_blockedToken", unique: true, using: :btree
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

  add_foreign_key "blocks", "devices"
  add_foreign_key "souls", "devices"
end
