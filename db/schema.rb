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

ActiveRecord::Schema.define(version: 20160330201017) do

  create_table "albums", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.date     "start"
    t.date     "end"
    t.string   "make",       limit: 255
    t.string   "model",      limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "country",    limit: 255
    t.string   "city",       limit: 255
    t.text     "photo_ids",  limit: 65535
    t.string   "album_type", limit: 255
  end

  create_table "catalogs", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "path",              limit: 255
    t.boolean  "default"
    t.text     "watch_path",        limit: 65535
    t.string   "type",              limit: 255
    t.string   "sync_from_albums",  limit: 255
    t.integer  "sync_from_catalog", limit: 4
    t.string   "ext_store_data",    limit: 255
    t.boolean  "import_mode"
  end

  create_table "instances", force: :cascade do |t|
    t.integer  "photo_id",   limit: 4
    t.integer  "catalog_id", limit: 4
    t.string   "path",       limit: 255
    t.integer  "size",       limit: 4
    t.datetime "modified"
    t.integer  "status",     limit: 4
    t.string   "rev",        limit: 255
  end

  add_index "instances", ["photo_id", "catalog_id"], name: "index_instances_on_photo_id_and_catalog_id", unique: true, using: :btree

  create_table "jobs", force: :cascade do |t|
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "job_type",     limit: 255
    t.string   "job_error",    limit: 255
    t.string   "arguments",    limit: 255
    t.datetime "completed_at"
    t.string   "queue",        limit: 255
    t.integer  "status",       limit: 4
  end

  create_table "locations", force: :cascade do |t|
    t.string   "status",     limit: 255
    t.decimal  "latitude",               precision: 16, scale: 10
    t.decimal  "longitude",              precision: 16, scale: 10
    t.string   "location",   limit: 255
    t.string   "country",    limit: 255
    t.string   "state",      limit: 255
    t.string   "address",    limit: 255
    t.string   "road",       limit: 255
    t.string   "city",       limit: 255
    t.string   "suburb",     limit: 255
    t.string   "postcode",   limit: 255
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  create_table "photos", force: :cascade do |t|
    t.string   "filename",        limit: 255
    t.datetime "date_taken"
    t.string   "path",            limit: 255
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.string   "file_thumb_path", limit: 255
    t.string   "file_extension",  limit: 255
    t.integer  "file_size",       limit: 4
    t.integer  "location_id",     limit: 4
    t.string   "make",            limit: 255
    t.string   "model",           limit: 255
    t.integer  "original_height", limit: 4
    t.integer  "original_width",  limit: 4
    t.decimal  "longitude",                     precision: 16, scale: 10
    t.decimal  "latitude",                      precision: 16, scale: 10
    t.integer  "status",          limit: 4
    t.text     "phash",           limit: 65535
  end

  add_index "photos", ["location_id"], name: "index_photos_on_location_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "name",                   limit: 255
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size",       limit: 4
    t.datetime "avatar_updated_at"
    t.string   "avatar",                 limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
