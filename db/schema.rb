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

ActiveRecord::Schema.define(:version => 20120120220314) do

  create_table "access_levels", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_name"
    t.integer  "numeric_level", :precision => 38, :scale => 0
  end

  create_table "annotations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "text"
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
    t.integer  "area_id",      :precision => 38, :scale => 0
    t.string   "abbreviation"
    t.boolean  "is_residence", :precision => 1,  :scale => 0, :default => false
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
    t.integer  "year",          :precision => 38, :scale => 0
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
    t.integer  "processed",        :precision => 38, :scale => 0, :default => 0
    t.string   "csv_file_name"
    t.string   "csv_content_type"
    t.integer  "csv_file_size",    :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interested_parties", :force => true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "authorized_by_id", :precision => 38, :scale => 0
    t.integer  "report_type_id",   :precision => 38, :scale => 0
  end

  create_table "interested_party_reports", :force => true do |t|
    t.integer  "interested_party_id", :precision => 38, :scale => 0
    t.integer  "report_id",           :precision => 38, :scale => 0
    t.integer  "times_forwarded",     :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.integer  "staff_id",            :precision => 38, :scale => 0
  end

  create_table "notification_preferences", :force => true do |t|
    t.integer  "staff_id",      :precision => 38, :scale => 0
    t.string   "report_type"
    t.integer  "frequency",     :precision => 38, :scale => 0
    t.integer  "time_offset",   :precision => 38, :scale => 0
    t.integer  "scope",         :precision => 38, :scale => 0
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
    t.integer  "building_id",            :precision => 38, :scale => 0
    t.string   "student_id"
    t.string   "full_name"
    t.datetime "birthday"
    t.string   "extension"
    t.string   "emContact"
    t.string   "email"
    t.string   "classification"
    t.string   "emergency_contact_name"
    t.string   "middle_initial"
    t.boolean  "is_active",              :precision => 1,  :scale => 0, :default => true
  end

  create_table "relationship_to_reports", :force => true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "report_type_id", :precision => 38, :scale => 0
  end

  create_table "report_adjuncts", :force => true do |t|
    t.integer  "report_id",  :precision => 38, :scale => 0
    t.integer  "staff_id",   :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "report_fields", :force => true do |t|
    t.integer  "report_type_id",  :precision => 38, :scale => 0
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "edit_position",   :precision => 38, :scale => 0
    t.integer  "index_position",  :precision => 38, :scale => 0
    t.integer  "search_position", :precision => 38, :scale => 0
    t.integer  "show_position",   :precision => 38, :scale => 0
  end

  create_table "report_participants", :force => true do |t|
    t.integer  "relationship_to_report_id", :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "participant_id",            :precision => 38, :scale => 0
    t.string   "report_id"
    t.string   "context"
    t.integer  "annotation_id",             :precision => 38, :scale => 0
    t.integer  "contact_duration",          :precision => 38, :scale => 0
  end

  create_table "report_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "display_name"
    t.string   "abbreviation"
    t.integer  "organization_id",            :precision => 38, :scale => 0
    t.boolean  "forwardable",                :precision => 1,  :scale => 0
    t.string   "reason_context"
    t.boolean  "edit_on_mobile",             :precision => 1,  :scale => 0
    t.boolean  "submit_on_mobile",           :precision => 1,  :scale => 0
    t.boolean  "selectable_contact_reasons", :precision => 1,  :scale => 0
    t.boolean  "has_contact_reason_details", :precision => 1,  :scale => 0
    t.string   "path_to_reason_context"
  end

  create_table "report_view_logs", :force => true do |t|
    t.integer  "staff_id",   :precision => 38, :scale => 0
    t.integer  "report_id",  :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "building_id",     :precision => 38, :scale => 0
    t.datetime "approach_time"
    t.string   "room_number"
    t.string   "type"
    t.integer  "staff_id",        :precision => 38, :scale => 0
    t.boolean  "submitted",       :precision => 1,  :scale => 0
    t.integer  "annotation_id",   :precision => 38, :scale => 0
    t.string   "tag"
    t.integer  "organization_id", :precision => 38, :scale => 0
  end

  create_table "residence_life_organizations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rounds", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "shift_id",   :precision => 38, :scale => 0
    t.datetime "end_time"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shifts", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "staff_id",      :precision => 38, :scale => 0
    t.datetime "time_out"
    t.integer  "area_id",       :precision => 38, :scale => 0
    t.integer  "annotation_id", :precision => 38, :scale => 0
  end

  create_table "staff_areas", :force => true do |t|
    t.integer  "staff_id",   :precision => 38, :scale => 0
    t.integer  "area_id",    :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "staff_organizations", :id => false, :force => true do |t|
    t.integer  "staff_id",        :precision => 38, :scale => 0
    t.integer  "organization_id", :precision => 38, :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "access_level_id", :precision => 38, :scale => 0
  end

  create_table "staffs", :force => true do |t|
    t.string   "email",                                                              :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128,                                :default => "", :null => false
    t.string   "password_salt",                                                      :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :precision => 38, :scale => 0, :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "access_level_id",                     :precision => 38, :scale => 0
    t.boolean  "active",                              :precision => 1,  :scale => 0
  end

  create_table "task_assignments", :force => true do |t|
    t.integer  "shift_id",   :precision => 38, :scale => 0
    t.integer  "task_id",    :precision => 38, :scale => 0
    t.boolean  "done",       :precision => 1,  :scale => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "note"
    t.integer  "area_id",    :precision => 38, :scale => 0
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "expires",    :precision => 1,  :scale => 0
    t.integer  "time",       :precision => 38, :scale => 0
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
