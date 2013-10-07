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

ActiveRecord::Schema.define(version: 20130924205717) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bill_groups", force: true do |t|
    t.string   "name"
    t.integer  "order"
    t.integer  "tariff_line_item_id"
    t.integer  "tariff_tariff_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tariff_billing_classes", force: true do |t|
    t.string   "name"
    t.string   "customer_type"
    t.string   "phases"
    t.string   "voltage"
    t.string   "units"
    t.float    "start"
    t.float    "end"
    t.integer  "tariff_territory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tariff_holidays", force: true do |t|
    t.string   "name"
    t.date     "date"
    t.decimal  "tariff_territory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tariff_indexed_rates", force: true do |t|
    t.float    "additional_charge"
    t.integer  "tariff_line_item_id"
    t.integer  "tariff_iso_rto_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tariff_iso_lmps", force: true do |t|
    t.string   "iso_rto"
    t.string   "hub"
    t.string   "da_rt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tariff_line_items", force: true do |t|
    t.string   "name"
    t.string   "type"
    t.date     "effective_date"
    t.date     "expiration_date"
    t.float    "rate"
    t.string   "tou_type"
    t.integer  "bill_group_order"
    t.integer  "tariff_tariff_id"
    t.integer  "tariff_season_id"
    t.integer  "bill_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tariff_lmp_rates", force: true do |t|
    t.date     "date"
    t.time     "time"
    t.float    "factor"
    t.integer  "tariff_iso_lmp_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tariff_load_classes", force: true do |t|
    t.string   "name"
    t.string   "customer_type"
    t.string   "voltage"
    t.string   "units"
    t.float    "start"
    t.float    "end"
    t.string   "weather_zone"
    t.integer  "tariff_territory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tariff_meter_reads", force: true do |t|
    t.date     "date"
    t.string   "billing_month"
    t.string   "billing_year"
    t.integer  "tariff_territory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tariff_muni_franchise_costs", force: true do |t|
    t.string   "city"
    t.float    "rate"
    t.integer  "tariff_line_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tariff_season", force: true do |t|
    t.string   "season_type"
    t.date     "start_date"
    t.string   "end_date_date"
    t.integer  "tariff_territory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tariff_seasons", force: true do |t|
    t.string   "season_type"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "tariff_territory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tariff_settlement_load_profiles", force: true do |t|
    t.string   "date"
    t.time     "time"
    t.float    "factor"
    t.integer  "tariff_load_class_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tariff_stepped_rates", force: true do |t|
    t.string   "unit"
    t.float    "start"
    t.float    "end"
    t.float    "rate"
    t.string   "city"
    t.integer  "tariff_line_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tariff_tariffs", force: true do |t|
    t.string   "name"
    t.string   "type"
    t.integer  "tariff_billing_class_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tariff_territories", force: true do |t|
    t.string   "name"
    t.integer  "tariff_utility_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tariff_territories", ["tariff_utility_id"], name: "index_tariff_territories_on_tariff_utility_id", using: :btree

  create_table "tariff_territory_zip_code_rels", force: true do |t|
    t.integer  "tariff_territory_id"
    t.integer  "tariff_zip_code_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tariff_tous", force: true do |t|
    t.string   "type"
    t.string   "day_of_week"
    t.time     "start_time"
    t.time     "end_time"
    t.integer  "tariff_seasons_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tariff_utilities", force: true do |t|
    t.string   "name"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tariff_zip_codes", force: true do |t|
    t.string   "zip_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
