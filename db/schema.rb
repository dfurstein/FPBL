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

ActiveRecord::Schema.define(:version => 20131113043058) do

  create_table "contracts", :force => true do |t|
    t.integer  "player_id",                                  :null => false
    t.integer  "franchise_id",                               :null => false
    t.integer  "year",                                       :null => false
    t.decimal  "salary",       :precision => 3, :scale => 1, :null => false
    t.boolean  "release",                                    :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "owners", :force => true do |t|
    t.string   "first_name", :null => false
    t.string   "last_name",  :null => false
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "performances", :force => true do |t|
    t.integer  "year",          :null => false
    t.integer  "franchise_id",  :null => false
    t.string   "league",        :null => false
    t.string   "division",      :null => false
    t.integer  "wins",          :null => false
    t.integer  "losses",        :null => false
    t.integer  "streak",        :null => false
    t.string   "playoff_berth"
    t.string   "playoff_depth"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "performances", ["year", "franchise_id"], :name => "index_performances_on_year_and_franchise_id", :unique => true

  create_table "players", :force => true do |t|
    t.integer  "dmb_id",     :null => false
    t.string   "first_name", :null => false
    t.string   "last_name",  :null => false
    t.string   "position",   :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "seasons", :force => true do |t|
    t.integer  "year",         :null => false
    t.integer  "franchise_id", :null => false
    t.integer  "team_id",      :null => false
    t.integer  "owner_id",     :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "seasons", ["year", "franchise_id"], :name => "index_seasons_on_year_and_franchise_id", :unique => true

  create_table "teams", :force => true do |t|
    t.string   "location",     :null => false
    t.string   "nickname",     :null => false
    t.string   "abbreviation", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

end
