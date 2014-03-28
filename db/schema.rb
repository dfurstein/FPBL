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

ActiveRecord::Schema.define(:version => 20140327222927) do

  create_table "contracts", :force => true do |t|
    t.integer  "player_id",                                  :null => false
    t.integer  "franchise_id",                               :null => false
    t.integer  "year",                                       :null => false
    t.decimal  "salary",       :precision => 3, :scale => 1, :null => false
    t.boolean  "release",                                    :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "games", :force => true do |t|
    t.date     "date",               :null => false
    t.string   "dmb_id",             :null => false
    t.string   "team",               :null => false
    t.string   "position",           :null => false
    t.integer  "at_bat"
    t.integer  "run"
    t.integer  "hit"
    t.integer  "run_batted_in"
    t.integer  "double"
    t.integer  "triple"
    t.integer  "homerun"
    t.integer  "steal"
    t.integer  "caught_stealing"
    t.integer  "strike_out"
    t.integer  "walk"
    t.boolean  "win"
    t.boolean  "loss"
    t.boolean  "hold"
    t.boolean  "save_game"
    t.boolean  "blown_save"
    t.decimal  "inning"
    t.integer  "allowed_hit"
    t.integer  "allowed_run"
    t.integer  "allowed_earned_run"
    t.integer  "allowed_walk"
    t.integer  "allowed_strike_out"
    t.integer  "error"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "games", ["date", "dmb_id"], :name => "index_games_on_date_and_dmb_id", :unique => true

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

  create_table "schedules", :force => true do |t|
    t.date     "date",          :null => false
    t.string   "away_team",     :null => false
    t.integer  "away_score",    :null => false
    t.string   "home_team",     :null => false
    t.integer  "home_score",    :null => false
    t.integer  "extra_innings"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "schedules", ["date", "home_team"], :name => "index_schedules_on_date_and_home_team", :unique => true

  create_table "seasons", :force => true do |t|
    t.integer  "year",         :null => false
    t.integer  "franchise_id", :null => false
    t.integer  "team_id",      :null => false
    t.integer  "owner_id",     :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "dmb_id"
  end

  add_index "seasons", ["year", "franchise_id"], :name => "index_seasons_on_year_and_franchise_id", :unique => true

  create_table "teams", :force => true do |t|
    t.string   "location",     :null => false
    t.string   "nickname",     :null => false
    t.string   "abbreviation", :null => false
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "dmb_id"
  end

end
