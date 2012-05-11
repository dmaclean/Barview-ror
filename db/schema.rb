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

ActiveRecord::Schema.define(:version => 20120510231731) do

  create_table "admins", :force => true do |t|
    t.string   "name"
    t.string   "hashed_password"
    t.string   "salt"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "bar_events", :force => true do |t|
    t.integer  "bar_id"
    t.text     "detail"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bar_image_requests", :force => true do |t|
    t.integer  "bar_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "barimages", :force => true do |t|
    t.integer  "bar_id"
    t.string   "image"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bars", :force => true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.float    "lat"
    t.float    "lng"
    t.string   "username"
    t.string   "email"
    t.text     "reference"
    t.integer  "verified"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "hashed_password"
    t.string   "salt"
  end

  create_table "favorites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "bar_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_questionnaire_answers", :force => true do |t|
    t.integer  "user_questionnaire_question_id"
    t.integer  "user_id"
    t.integer  "user_questionnaire_option_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "user_questionnaire_options", :force => true do |t|
    t.integer  "user_questionnaire_question_id"
    t.text     "answer"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "user_questionnaire_questions", :force => true do |t|
    t.text     "question"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "hashed_password"
    t.date     "dob"
    t.string   "city"
    t.string   "state"
    t.string   "gender"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "salt"
  end

end
