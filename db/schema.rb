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

ActiveRecord::Schema.define(:version => 20131029191158) do

  create_table "owners", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "performances", :force => true do |t|
    t.integer  "year"
    t.integer  "franchise_id"
    t.string   "league"
    t.string   "division"
    t.integer  "wins"
    t.integer  "losses"
    t.integer  "streak"
    t.string   "playoff_berth"
    t.string   "playoff_depth"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "performances", ["year", "franchise_id"], :name => "index_performances_on_year_and_franchise_id", :unique => true

  create_table "seasons", :force => true do |t|
    t.integer  "year"
    t.integer  "franchise_id"
    t.integer  "team_id"
    t.integer  "owner_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "seasons", ["year", "franchise_id"], :name => "index_seasons_on_year_and_franchise_id", :unique => true

  create_table "teams", :force => true do |t|
    t.string   "location"
    t.string   "nickname"
    t.string   "abbreviation"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end
