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

ActiveRecord::Schema.define(version: 2020_07_28_065604) do

  create_table "counties", force: :cascade do |t|
    t.string "name", null: false
    t.integer "state_id", null: false
    t.integer "fips_code", limit: 2, null: false
    t.string "fips_class", limit: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state_id"], name: "index_counties_on_state_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.integer "county_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["county_id"], name: "index_events_on_county_id"
  end

  create_table "news_items", force: :cascade do |t|
    t.string "title", null: false
    t.string "link", null: false
    t.text "description"
    t.integer "representative_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["representative_id"], name: "index_news_items_on_representative_id"
  end

  create_table "representatives", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ocdid"
    t.string "title"
  end

  create_table "states", force: :cascade do |t|
    t.string "name", null: false
    t.string "symbol", null: false
    t.integer "fips_code", limit: 1, null: false
    t.integer "is_territory", null: false
    t.float "lat_min", null: false
    t.float "lat_max", null: false
    t.float "long_min", null: false
    t.float "long_max", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.integer "provider", null: false
    t.string "uid", null: false
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid", "provider"], name: "index_users_on_uid_provider", unique: true
  end

end
