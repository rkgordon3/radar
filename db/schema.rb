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

ActiveRecord::Schema.define(:version => 20110219074253) do

  create_table "annotations", :force => true do |t|
    t.string   "text"
    t.integer  "staff_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "report_id"
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

  create_table "infractions", :force => true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.string   "detail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "participants", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "cell_phone"
    t.string   "home_phone"
    t.string   "affiliation"
    t.integer  "age"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "photo_id"
    t.string   "room_number"
    t.integer  "building_id"
  end

  create_table "photos", :force => true do |t|
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reported_infractions", :force => true do |t|
    t.integer  "infraction_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "participant_id"
    t.string   "incident_report_id"
  end

  create_table "reports", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "building_id"
    t.datetime "approach_time"
    t.string   "annotation"
    t.string   "room_number"
    t.string   "type"
    t.integer  "staff_id"
  end

  create_table "staffs", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "user_name"
    t.string   "password"
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
