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

ActiveRecord::Schema.define(:version => 20131120123836) do

  create_table "access_levels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_name"
    t.integer  "numeric_level"
  end

  create_table "annotations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "text",       :limit => 20480
  end

  create_table "areas", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "abbreviation"
  end

  create_table "buildings", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.integer  "area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_residence", :default => false
  end

  create_table "by_appointments", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "courses", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "department"
    t.string   "course_number"
    t.string   "section"
    t.string   "semester"
    t.integer  "year"
    t.string   "term"
    t.string   "full_name"
  end

  create_table "enrollments", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "course_id"
    t.string   "student_id"
  end

  create_table "imports", :force => true do |t|
    t.string   "datatype"
    t.integer  "processed",        :default => 0
    t.string   "csv_file_name"
    t.string   "csv_content_type"
    t.integer  "csv_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interested_parties", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "authorized_by_id"
    t.integer  "report_type_id"
  end

  create_table "interested_party_reports", :force => true do |t|
    t.integer  "interested_party_id"
    t.integer  "report_id"
    t.integer  "times_forwarded"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.integer  "staff_id"
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

  create_table "organizations", :force => true do |t|
    t.string   "display_name"
    t.string   "abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
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
    t.string   "middle_initial"
    t.boolean  "is_active",              :default => true
  end

  create_table "preferences", :force => true do |t|
    t.string   "staff_id"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "relationship_to_reports", :force => true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "report_type_id"
    t.integer  "organization_id"
  end

  create_table "report_adjuncts", :force => true do |t|
    t.integer  "report_id"
    t.integer  "staff_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "report_fields", :force => true do |t|
    t.integer  "report_type_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "edit_position"
    t.integer  "index_position"
    t.integer  "search_position"
    t.integer  "show_position"
  end

  create_table "report_participants", :force => true do |t|
    t.integer  "relationship_to_report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "participant_id"
    t.string   "report_id"
    t.string   "context"
    t.integer  "annotation_id"
    t.integer  "contact_duration"
  end

  create_table "report_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "abbreviation"
    t.string   "display_name"
    t.integer  "organization_id"
    t.boolean  "forwardable"
    t.string   "reason_context"
    t.boolean  "edit_on_mobile"
    t.boolean  "submit_on_mobile"
    t.boolean  "selectable_contact_reasons"
    t.boolean  "has_contact_reason_details"
    t.string   "path_to_reason_context"
    t.integer  "default_reason_id"
  end

  create_table "report_view_logs", :force => true do |t|
    t.integer  "staff_id"
    t.integer  "report_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "building_id"
    t.datetime "approach_time"
    t.string   "room_number"
    t.string   "type",            :default => "Report"
    t.integer  "staff_id"
    t.boolean  "submitted"
    t.integer  "annotation_id"
    t.string   "tag"
    t.integer  "organization_id"
    t.integer  "parent_id"
  end

  create_table "residence_life_organizations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.integer  "area_id"
    t.integer  "annotation_id"
  end

  create_table "staff_areas", :force => true do |t|
    t.integer  "staff_id"
    t.integer  "area_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "staff_organizations", :force => true do |t|
    t.integer  "staff_id"
    t.integer  "organization_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "access_level_id"
  end

  create_table "staffs", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "password_salt",                       :default => ""
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
    t.integer  "access_level_id"
    t.boolean  "active"
  end

  add_index "staffs", ["email"], :name => "index_staffs_on_email", :unique => true
  add_index "staffs", ["reset_password_token"], :name => "index_staffs_on_reset_password_token", :unique => true

  create_table "task_assignments", :force => true do |t|
    t.integer  "shift_id"
    t.integer  "task_id"
    t.boolean  "done"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "note"
    t.integer  "area_id"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "expires"
    t.integer  "time"
  end

  create_table "tutor_reports", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "url_for_ids", :force => true do |t|
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
