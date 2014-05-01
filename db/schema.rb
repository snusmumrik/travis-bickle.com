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

ActiveRecord::Schema.define(:version => 20140429072149) do

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
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "advertisements", :force => true do |t|
    t.string   "name"
    t.string   "youtube_videoid"
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps",           :default => true
    t.datetime "deleted_at"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "api_talks", :force => true do |t|
    t.integer  "sender_user_id"
    t.integer  "sender_car_id"
    t.integer  "receiver_user_id"
    t.integer  "receiver_car_id"
    t.binary   "contents"
    t.boolean  "received"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "cars", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "base_fare"
    t.integer  "meter_fare"
    t.integer  "initial_meter"
    t.integer  "meter_fare_segment"
    t.string   "access_token"
    t.string   "device_token"
    t.datetime "deleted_at"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "cars", ["device_token"], :name => "index_cars_on_device_token"
  add_index "cars", ["user_id"], :name => "index_cars_on_user_id"

  create_table "check_point_statuses", :force => true do |t|
    t.integer  "report_id"
    t.integer  "check_point_id"
    t.string   "status"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.datetime "deleted_at"
  end

  add_index "check_point_statuses", ["check_point_id"], :name => "index_check_point_statuses_on_check_point_id"
  add_index "check_point_statuses", ["report_id"], :name => "index_check_point_statuses_on_report_id"

  create_table "check_points", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "deleted_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "check_points", ["user_id"], :name => "index_check_points_on_user_id"

  create_table "device_tokens", :force => true do |t|
    t.integer  "user_id"
    t.string   "device_token"
    t.datetime "deleted_at"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "device_tokens", ["user_id"], :name => "index_device_tokens_on_user_id"

  create_table "drivers", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.string   "device_token"
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
    t.integer  "report_id"
    t.integer  "meter",            :default => 0
    t.integer  "mileage",          :default => 0
    t.integer  "riding_mileage",   :default => 0
    t.integer  "riding_count",     :default => 0
    t.integer  "meter_fare_count"
    t.datetime "deleted_at"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "meters", ["report_id"], :name => "index_meters_on_report_id"

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "car_id"
    t.string   "text"
    t.datetime "accepted_at"
    t.datetime "canceled_at"
    t.datetime "sent_at"
    t.datetime "deleted_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "notifications", ["car_id"], :name => "index_notifications_on_car_id"

  create_table "pickup_locations", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.datetime "deleted_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "pickup_locations", ["user_id"], :name => "index_pickup_locations_on_user_id"

  create_table "reports", :force => true do |t|
    t.integer  "driver_id"
    t.integer  "car_id"
    t.integer  "mileage",            :default => 0
    t.integer  "riding_mileage",     :default => 0
    t.integer  "riding_count",       :default => 0
    t.integer  "meter_fare_count",   :default => 0
    t.integer  "passengers",         :default => 0
    t.integer  "sales",              :default => 0
    t.integer  "extra_sales",        :default => 0
    t.integer  "fuel_cost",          :default => 0
    t.integer  "ticket",             :default => 0
    t.integer  "edy",                :default => 0
    t.integer  "account_receivable", :default => 0
    t.integer  "cash",               :default => 0
    t.integer  "surplus_funds",      :default => 0
    t.integer  "deficiency_account", :default => 0
    t.integer  "advance",            :default => 0
    t.datetime "started_at"
    t.datetime "finished_at"
    t.datetime "deleted_at"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "reports", ["driver_id"], :name => "index_reports_on_driver_id"

  create_table "rests", :force => true do |t|
    t.integer  "report_id"
    t.string   "location"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
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
    t.integer  "passengers",      :default => 0
    t.integer  "fare",            :default => 0
    t.integer  "segment",         :default => 0
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "deleted_at"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "rides", ["report_id"], :name => "index_rides_on_report_id"

  create_table "talks", :force => true do |t|
    t.integer  "sender_user_id"
    t.integer  "sender_car_id"
    t.integer  "receiver_user_id"
    t.integer  "receiver_car_id"
    t.boolean  "received"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.string   "audio_file_name"
    t.string   "audio_content_type"
    t.integer  "audio_file_size"
    t.datetime "audio_updated_at"
  end

  add_index "talks", ["receiver_car_id"], :name => "index_talks_on_receiver_car_id"
  add_index "talks", ["receiver_user_id"], :name => "index_talks_on_receiver_user_id"
  add_index "talks", ["sender_car_id"], :name => "index_talks_on_sender_car_id"
  add_index "talks", ["sender_user_id"], :name => "index_talks_on_sender_user_id"

  create_table "transfer_slips", :force => true do |t|
    t.integer  "user_id"
    t.integer  "report_id"
    t.date     "date"
    t.string   "debit"
    t.integer  "debit_amount"
    t.string   "credit"
    t.integer  "credit_amount"
    t.string   "note"
    t.boolean  "whole_day"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.datetime "deleted_at"
  end

  add_index "transfer_slips", ["report_id"], :name => "index_transfer_slips_on_report_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "person_in_charge"
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "deleted_at"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
