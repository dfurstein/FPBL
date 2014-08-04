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

ActiveRecord::Schema.define(:version => 20140324211205) do

  create_table "boxscores", :id => false, :force => true do |t|
    t.date     "date",                                :null => false
    t.string   "dmb_name",                            :null => false
    t.string   "team",                                :null => false
    t.string   "position",                            :null => false
    t.string   "played_against",                      :null => false
    t.boolean  "is_home_team",                        :null => false
    t.integer  "at_bat",             :default => 0
    t.integer  "run",                :default => 0
    t.integer  "hit",                :default => 0
    t.integer  "run_batted_in",      :default => 0
    t.integer  "double",             :default => 0
    t.integer  "triple",             :default => 0
    t.integer  "homerun",            :default => 0
    t.integer  "steal",              :default => 0
    t.integer  "caught_stealing",    :default => 0
    t.integer  "strike_out",         :default => 0
    t.integer  "walk",               :default => 0
    t.integer  "sacrifice_fly",      :default => 0
    t.integer  "sacrifice",          :default => 0
    t.integer  "hit_by_pitch",       :default => 0
    t.integer  "win",                :default => 0
    t.integer  "loss",               :default => 0
    t.integer  "hold",               :default => 0
    t.integer  "save_game",          :default => 0
    t.integer  "blown_save",         :default => 0
    t.decimal  "inning",             :default => 0.0
    t.integer  "allowed_hit",        :default => 0
    t.integer  "allowed_run",        :default => 0
    t.integer  "allowed_earned_run", :default => 0
    t.integer  "allowed_walk",       :default => 0
    t.integer  "allowed_strike_out", :default => 0
    t.integer  "hit_batter",         :default => 0
    t.integer  "wild_pitch",         :default => 0
    t.integer  "passed_ball",        :default => 0
    t.integer  "balk",               :default => 0
    t.integer  "error",              :default => 0
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "boxscores", ["date", "dmb_name"], :name => "index_boxscores_on_date_and_dmb_name", :unique => true

  create_table "contracts", :id => false, :force => true do |t|
    t.integer  "player_id",                                                     :null => false
    t.integer  "franchise_id",                                                  :null => false
    t.integer  "year",                                                          :null => false
    t.decimal  "salary",       :precision => 3, :scale => 1,                    :null => false
    t.boolean  "released",                                   :default => false, :null => false
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
  end

  add_index "contracts", ["year", "player_id", "franchise_id"], :name => "index_contracts_on_year_and_player_id_and_franchise_id", :unique => true

  create_table "owners", :force => true do |t|
    t.string   "first_name", :null => false
    t.string   "last_name",  :null => false
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "players", :id => false, :force => true do |t|
    t.integer  "player_id",  :null => false
    t.integer  "year",       :null => false
    t.string   "dmb_name",   :null => false
    t.string   "first_name", :null => false
    t.string   "last_name",  :null => false
    t.string   "position",   :null => false
    t.string   "hand"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "players", ["year", "player_id"], :name => "index_players_on_year_and_player_id", :unique => true

  create_table "schedules", :id => false, :force => true do |t|
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

  create_table "standings", :id => false, :force => true do |t|
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

  add_index "standings", ["year", "franchise_id"], :name => "index_standings_on_year_and_franchise_id", :unique => true

  create_table "teams", :id => false, :force => true do |t|
    t.integer "franchise_id",                               :null => false
    t.integer "year",                                       :null => false
    t.string  "city",                                       :null => false
    t.string  "nickname",                                   :null => false
    t.string  "abbreviation",                               :null => false
    t.string  "stadium"
    t.integer "owner_id",                                   :null => false
    t.decimal "salary_cap",   :precision => 3, :scale => 1
    t.integer "dmb_id"
  end

  add_index "teams", ["year", "franchise_id"], :name => "index_teams_on_year_and_franchise_id", :unique => true

end
