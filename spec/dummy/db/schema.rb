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

ActiveRecord::Schema.define(:version => 20121011192323) do

  create_table "embeddable_multiple_choice_choices", :force => true do |t|
    t.integer  "multiple_choice_id"
    t.text     "choice"
    t.boolean  "is_correct"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "embeddable_multiple_choices", :force => true do |t|
    t.string   "name"
    t.text     "prompt"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "embeddable_open_responses", :force => true do |t|
    t.string   "name"
    t.text     "prompt"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "embeddable_xhtmls", :force => true do |t|
    t.string   "name"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lightweight_interactive_items", :force => true do |t|
    t.integer  "interactive_page_id"
    t.integer  "interactive_id"
    t.string   "interactive_type"
    t.integer  "position"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "lightweight_interactive_items", ["interactive_id", "interactive_type"], :name => "interactive_items_interactive_idx"
  add_index "lightweight_interactive_items", ["interactive_page_id", "position"], :name => "interactive_items_by_page_idx"

  create_table "lightweight_interactive_pages", :force => true do |t|
    t.string   "name"
    t.integer  "lightweight_activity_id"
    t.integer  "user_id"
    t.integer  "position"
    t.text     "text"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.string   "theme",                   :default => "default"
    t.integer  "offerings_count"
    t.text     "sidebar"
  end

  add_index "lightweight_interactive_pages", ["lightweight_activity_id", "position"], :name => "interactive_pages_by_activity_idx"
  add_index "lightweight_interactive_pages", ["user_id"], :name => "interactive_pages_user_idx"

  create_table "lightweight_lightweight_activities", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.string   "publication_status"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
    t.integer  "offerings_count"
    t.text     "related"
    t.text     "description"
  end

  add_index "lightweight_lightweight_activities", ["publication_status"], :name => "lightweight_activities_publication_status_idx"
  add_index "lightweight_lightweight_activities", ["user_id"], :name => "lightweight_activities_user_idx"

  create_table "lightweight_mw_interactives", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "user_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.float    "width",      :default => 60.0
  end

  add_index "lightweight_mw_interactives", ["user_id"], :name => "mw_interactives_user_idx"

  create_table "lightweight_page_items", :force => true do |t|
    t.integer  "interactive_page_id"
    t.integer  "embeddable_id"
    t.string   "embeddable_type"
    t.integer  "position"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "portal_learners", :force => true do |t|
    t.string   "uuid",        :limit => 36
    t.integer  "offering_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "portal_offerings", :force => true do |t|
    t.string   "uuid",          :limit => 36
    t.string   "status"
    t.integer  "runnable_id"
    t.string   "runnable_type"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.boolean  "active",                      :default => true
    t.integer  "position",                    :default => 0
  end

  create_table "saveable_multiple_choice_answers", :force => true do |t|
    t.integer  "multiple_choice_id"
    t.integer  "choice_id"
    t.integer  "position"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "saveable_multiple_choices", :force => true do |t|
    t.integer  "learner_id",         :default => 1
    t.integer  "offering_id"
    t.integer  "multiple_choice_id"
    t.integer  "response_count",     :default => 0
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "saveable_open_response_answers", :force => true do |t|
    t.integer  "open_response_id"
    t.integer  "position"
    t.text     "answer"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "saveable_open_responses", :force => true do |t|
    t.integer  "learner_id",       :default => 1
    t.integer  "open_response_id"
    t.integer  "offering_id"
    t.integer  "response_count",   :default => 0
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

end
