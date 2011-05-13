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

ActiveRecord::Schema.define(:version => 20110513170842) do

  create_table "annotations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "text"
  end

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "abbreviation"
  end

  create_table "buildings", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "area_id"
    t.string   "abbreviation"
  end

  create_table "notification_preferences", :force => true do |t|
    t.integer  "staff_id"
    t.string   "report_type"
    t.integer  "frequency"
    t.integer  "time_offset"
    t.integer  "scope"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_notified"
  end

  create_table "participants", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "cell_phone"
    t.string   "home_phone"
    t.string   "affiliation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.string   "room_number"
    t.integer  "building_id"
    t.string   "student_id"
    t.string   "full_name"
    t.datetime "birthday"
    t.string   "extension"
    t.string   "emContact"
    t.string   "email"
    t.string   "classification"
    t.string   "emergency_contact_name"
  end

  create_table "relationship_to_reports", :force => true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "report_participant_relationships", :force => true do |t|
    t.integer  "relationship_to_report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "participant_id"
    t.string   "report_id"
  end

  create_table "report_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_name"
    t.string   "abbreviation"
  end

  create_table "reports", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "building_id"
    t.datetime "approach_time"
    t.string   "room_number"
    t.string   "type"
    t.integer  "staff_id"
    t.boolean  "submitted"
    t.integer  "annotation_id"
    t.string   "tag"
  end

  create_table "rounds", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shift_id"
    t.datetime "end_time"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "shifts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "staff_id"
    t.datetime "time_out"
  end

  create_table "staffs", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "access_level"
    t.boolean  "active"
  end

  add_index "staffs", ["email"], :name => "index_staffs_on_email", :unique => true
  add_index "staffs", ["reset_password_token"], :name => "index_staffs_on_reset_password_token", :unique => true

  create_table "tasks", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "note"
  end

end
