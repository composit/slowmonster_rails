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

ActiveRecord::Schema.define(:version => 20120830212358) do

  create_table "task_amounts", :force => true do |t|
    t.decimal  "amount"
    t.datetime "incurred_at"
    t.integer  "task_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "task_amounts", ["task_id"], :name => "index_task_amounts_on_task_id"

  create_table "task_joiners", :force => true do |t|
    t.integer  "parent_task_id"
    t.integer  "child_task_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "multiplier"
  end

  add_index "task_joiners", ["child_task_id"], :name => "index_task_joiners_on_child_task_id"
  add_index "task_joiners", ["parent_task_id"], :name => "index_task_joiners_on_parent_task_id"

  create_table "task_times", :force => true do |t|
    t.datetime "started_at"
    t.datetime "ended_at"
    t.integer  "task_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "task_times", ["task_id"], :name => "index_task_times_on_task_id"

  create_table "tasks", :force => true do |t|
    t.string   "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.integer  "priority"
  end

  add_index "tasks", ["user_id"], :name => "index_tasks_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "email"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
