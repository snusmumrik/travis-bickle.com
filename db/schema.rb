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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130208074529) do

  create_table "active_admin_comments", :force => true do |t|
    t.integer  "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.string   "namespace"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "cars", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "base_fare"
    t.integer  "meter_fare"
    t.string   "access_token"
    t.string   "device_token"
    t.datetime "deleted_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "cars", ["user_id"], :name => "index_cars_on_user_id"

  create_table "check_points", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "check_points", ["user_id"], :name => "index_check_points_on_user_id"

  create_table "drivers", :force => true do |t|
    t.integer  "user_id"
    t.string   "tc_user_id"
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "deleted_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "drivers", ["user_id"], :name => "index_drivers_on_user_id"

  create_table "images", :force => true do |t|
    t.string   "type"
    t.string   "parent_type"
    t.integer  "parent_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "locations", :force => true do |t|
    t.integer  "car_id"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "locations", ["car_id"], :name => "index_locations_on_car_id"

  create_table "meters", :force => true do |t|
    t.integer  "car_id"
    t.date     "date"
    t.integer  "meter"
    t.integer  "mileage"
    t.integer  "riding_mileage"
    t.integer  "riding_count"
    t.integer  "meter_fare_count"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "meters", ["car_id"], :name => "index_meters_on_car_id"

  create_table "reports", :force => true do |t|
    t.integer  "driver_id"
    t.integer  "car_id"
    t.date     "date"
    t.integer  "meter"
    t.integer  "mileage"
    t.integer  "riding_mileage"
    t.integer  "riding_count"
    t.integer  "meter_fare_count"
    t.integer  "passengers"
    t.integer  "sales"
    t.integer  "fuel_cost"
    t.integer  "ticket"
    t.integer  "account_receivable"
    t.integer  "cash"
    t.integer  "surplus_funds"
    t.integer  "deficiency_account"
    t.integer  "advance"
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "deleted_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "reports", ["driver_id"], :name => "index_reports_on_driver_id"

  create_table "rests", :force => true do |t|
    t.integer  "report_id"
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "deleted_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "rests", ["report_id"], :name => "index_rests_on_report_id"

  create_table "rides", :force => true do |t|
    t.integer  "report_id"
    t.float    "ride_latitude"
    t.float    "ride_longitude"
    t.string   "ride_address"
    t.float    "leave_latitude"
    t.float    "leave_longitude"
    t.string   "leave_address"
    t.integer  "passengers"
    t.integer  "fare"
    t.datetime "deleted_at"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "rides", ["report_id"], :name => "index_rides_on_report_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "deleted_at"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
