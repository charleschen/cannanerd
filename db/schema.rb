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

ActiveRecord::Schema.define(:version => 20111110000720) do

  create_table "answer_tags", :force => true do |t|
    t.integer  "answer_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answer_tags", ["answer_id", "tag_id"], :name => "index_answer_tags_on_answer_id_and_tag_id", :unique => true
  add_index "answer_tags", ["answer_id"], :name => "index_answer_tags_on_answer_id"
  add_index "answer_tags", ["tag_id"], :name => "index_answer_tags_on_tag_id"

  create_table "answers", :force => true do |t|
    t.text     "content"
    t.text     "old_content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answerships", :force => true do |t|
    t.integer  "answer_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answerships", ["answer_id"], :name => "index_answerships_on_answer_id"
  add_index "answerships", ["user_id", "answer_id"], :name => "index_answerships_on_user_id_and_answer_id", :unique => true
  add_index "answerships", ["user_id"], :name => "index_answerships_on_user_id"

  create_table "clubs", :force => true do |t|
    t.string   "email",                             :null => false
    t.string   "name",                              :null => false
    t.string   "crypted_password",                  :null => false
    t.string   "password_salt",                     :null => false
    t.string   "persistence_token",                 :null => false
    t.integer  "login_count",        :default => 0, :null => false
    t.integer  "failed_login_count", :default => 0, :null => false
    t.string   "perishable_token",                  :null => false
    t.float    "lat"
    t.float    "lng"
    t.string   "current_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "roles_mask",         :default => 1
  end

  create_table "questionaires", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "questions", :force => true do |t|
    t.text     "content"
    t.integer  "questionaire_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["category"], :name => "index_tags_on_category"
  add_index "tags", ["name"], :name => "index_tags_on_name"

  create_table "users", :force => true do |t|
    t.string   "name",                              :null => false
    t.string   "email",                             :null => false
    t.string   "crypted_password",                  :null => false
    t.string   "password_salt",                     :null => false
    t.string   "persistence_token",                 :null => false
    t.integer  "login_count",        :default => 0, :null => false
    t.integer  "failed_login_count", :default => 0, :null => false
    t.string   "perishable_token",                  :null => false
    t.string   "current_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "roles_mask",         :default => 1
  end

end
