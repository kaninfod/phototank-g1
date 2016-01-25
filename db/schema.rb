# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160125094336) do

  create_table "albums", force: :cascade do |t|
    t.string   "name"
    t.datetime "start"
    t.datetime "end"
    t.string   "make"
    t.string   "model"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "country"
    t.string   "city"
  end

  create_table "catalogs", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "path"
    t.boolean  "default"
    t.string   "watch_path"
  end

  create_table "doubles", force: :cascade do |t|
    t.text     "items"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "deleted"
  end

  create_table "instances", force: :cascade do |t|
    t.integer "photo_id"
    t.integer "catalog_id"
    t.string  "path"
  end

  add_index "instances", ["catalog_id"], name: "index_instances_on_catalog_id"
  add_index "instances", ["photo_id"], name: "index_instances_on_photo_id"

  create_table "locations", force: :cascade do |t|
    t.string   "status"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "location"
    t.string   "country"
    t.string   "state"
    t.string   "address"
    t.string   "road"
    t.string   "city"
    t.string   "suburb"
    t.string   "postcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "photos", force: :cascade do |t|
    t.string   "filename",        null: false
    t.datetime "date_taken",      null: false
    t.string   "path",            null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "file_thumb_path", null: false
    t.string   "file_extension",  null: false
    t.integer  "file_size",       null: false
    t.integer  "location_id"
    t.string   "make"
    t.string   "model"
    t.integer  "original_height"
    t.integer  "original_width"
    t.decimal  "longitude"
    t.decimal  "latitude"
  end

  add_index "photos", ["location_id"], name: "index_photos_on_location_id"

end
