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

ActiveRecord::Schema.define(version: 20180305160547) do

  create_table "addresses", force: :cascade do |t|
    t.string   "street"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.float    "lat"
    t.float    "lng"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "addresses", ["lat"], name: "index_addresses_on_lat"
  add_index "addresses", ["lng"], name: "index_addresses_on_lng"
  add_index "addresses", ["state"], name: "index_addresses_on_state"
  add_index "addresses", ["zip_code"], name: "index_addresses_on_zip_code"

  create_table "daily_vendor_order_duration_aggs", force: :cascade do |t|
    t.float    "lat"
    t.float    "lng"
    t.string   "zip_code"
    t.integer  "warehouse"
    t.integer  "dispatched"
    t.integer  "distribution"
    t.integer  "out_for_delivery"
    t.integer  "vendor_id"
    t.date     "date"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "daily_vendor_order_duration_aggs", ["dispatched"], name: "index_daily_vendor_order_duration_aggs_on_dispatched"
  add_index "daily_vendor_order_duration_aggs", ["distribution"], name: "index_daily_vendor_order_duration_aggs_on_distribution"
  add_index "daily_vendor_order_duration_aggs", ["lat"], name: "index_daily_vendor_order_duration_aggs_on_lat"
  add_index "daily_vendor_order_duration_aggs", ["lng"], name: "index_daily_vendor_order_duration_aggs_on_lng"
  add_index "daily_vendor_order_duration_aggs", ["out_for_delivery"], name: "index_daily_vendor_order_duration_aggs_on_out_for_delivery"
  add_index "daily_vendor_order_duration_aggs", ["vendor_id"], name: "index_daily_vendor_order_duration_aggs_on_vendor_id"
  add_index "daily_vendor_order_duration_aggs", ["warehouse"], name: "index_daily_vendor_order_duration_aggs_on_warehouse"
  add_index "daily_vendor_order_duration_aggs", ["zip_code"], name: "index_daily_vendor_order_duration_aggs_on_zip_code"

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority"

  create_table "orders", force: :cascade do |t|
    t.string   "number"
    t.string   "tracking_id"
    t.string   "zip_code"
    t.integer  "total"
    t.integer  "address_id"
    t.integer  "vendor_id"
    t.integer  "status",          default: 0
    t.integer  "tracking_status", default: 0
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "orders", ["address_id"], name: "index_orders_on_address_id"
  add_index "orders", ["number"], name: "index_orders_on_number"
  add_index "orders", ["tracking_id"], name: "index_orders_on_tracking_id"
  add_index "orders", ["vendor_id"], name: "index_orders_on_vendor_id"
  add_index "orders", ["zip_code"], name: "index_orders_on_zip_code"

  create_table "tracking_events", force: :cascade do |t|
    t.datetime "created_at",              null: false
    t.string   "tracking_id"
    t.integer  "status",      default: 0
    t.integer  "vendor_id"
    t.string   "zip_code"
    t.integer  "duration"
    t.datetime "updated_at",              null: false
  end

  add_index "tracking_events", ["created_at"], name: "index_tracking_events_on_created_at"
  add_index "tracking_events", ["status"], name: "index_tracking_events_on_status"
  add_index "tracking_events", ["tracking_id"], name: "index_tracking_events_on_tracking_id"
  add_index "tracking_events", ["vendor_id"], name: "index_tracking_events_on_vendor_id"
  add_index "tracking_events", ["zip_code"], name: "index_tracking_events_on_zip_code"

  create_table "vendor_order_duration_aggregates", force: :cascade do |t|
    t.string   "zip_code"
    t.float    "lat"
    t.float    "lng"
    t.integer  "warehouse"
    t.integer  "dispatched"
    t.integer  "distribution"
    t.integer  "out_for_delivery"
    t.integer  "vendor_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "vendor_order_duration_aggregates", ["dispatched"], name: "index_vendor_order_duration_aggregates_on_dispatched"
  add_index "vendor_order_duration_aggregates", ["distribution"], name: "index_vendor_order_duration_aggregates_on_distribution"
  add_index "vendor_order_duration_aggregates", ["lat"], name: "index_vendor_order_duration_aggregates_on_lat"
  add_index "vendor_order_duration_aggregates", ["lng"], name: "index_vendor_order_duration_aggregates_on_lng"
  add_index "vendor_order_duration_aggregates", ["out_for_delivery"], name: "index_vendor_order_duration_aggregates_on_out_for_delivery"
  add_index "vendor_order_duration_aggregates", ["vendor_id"], name: "index_vendor_order_duration_aggregates_on_vendor_id"
  add_index "vendor_order_duration_aggregates", ["warehouse"], name: "index_vendor_order_duration_aggregates_on_warehouse"
  add_index "vendor_order_duration_aggregates", ["zip_code"], name: "index_vendor_order_duration_aggregates_on_zip_code"

  create_table "vendors", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
