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

ActiveRecord::Schema.define(:version => 20141014032106) do

  create_table "boxscores", :id => false, :force => true do |t|
    t.date     "date",                               :null => false
    t.integer  "player_id",                          :null => false
    t.integer  "franchise_id",                       :null => false
    t.integer  "franchise_id_home",                  :null => false
    t.integer  "franchise_id_away",                  :null => false
    t.string   "position",                           :null => false
    t.integer  "AB",                :default => 0
    t.integer  "R",                 :default => 0
    t.integer  "H",                 :default => 0
    t.integer  "RBI",               :default => 0
    t.integer  "D",                 :default => 0
    t.integer  "T",                 :default => 0
    t.integer  "HR",                :default => 0
    t.integer  "SB",                :default => 0
    t.integer  "CS",                :default => 0
    t.integer  "K",                 :default => 0
    t.integer  "BB",                :default => 0
    t.integer  "SF",                :default => 0
    t.integer  "SAC",               :default => 0
    t.integer  "HBP",               :default => 0
    t.integer  "CI",                :default => 0
    t.integer  "W",                 :default => 0
    t.integer  "L",                 :default => 0
    t.integer  "HO",                :default => 0
    t.integer  "S",                 :default => 0
    t.integer  "BS",                :default => 0
    t.decimal  "IP",                :default => 0.0
    t.integer  "HA",                :default => 0
    t.integer  "RA",                :default => 0
    t.integer  "ER",                :default => 0
    t.integer  "BBA",               :default => 0
    t.integer  "KA",                :default => 0
    t.integer  "HB",                :default => 0
    t.integer  "WP",                :default => 0
    t.integer  "PB",                :default => 0
    t.integer  "BK",                :default => 0
    t.integer  "E",                 :default => 0
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "boxscores", ["date", "player_id"], :name => "index_boxscores_on_date_and_player_id", :unique => true

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

  create_table "drafts", :id => false, :force => true do |t|
    t.integer  "year",                  :null => false
    t.integer  "round",                 :null => false
    t.integer  "selection",             :null => false
    t.integer  "franchise_id_original"
    t.integer  "franchise_id_current"
    t.integer  "player_id"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "drafts", ["year", "round", "selection"], :name => "index_drafts_on_year_and_round_and_selection", :unique => true

  create_table "owners", :force => true do |t|
    t.string   "first_name", :null => false
    t.string   "last_name",  :null => false
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "players", :id => false, :force => true do |t|
    t.integer  "player_id",                    :null => false
    t.integer  "year",                         :null => false
    t.string   "dmb_name",                     :null => false
    t.string   "first_name",                   :null => false
    t.string   "last_name",                    :null => false
    t.string   "position",                     :null => false
    t.boolean  "active",     :default => true, :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "players", ["year", "player_id"], :name => "index_players_on_year_and_player_id", :unique => true

  create_table "schedules", :force => true do |t|
    t.date     "date",                   :null => false
    t.string   "away_team_abbreviation", :null => false
    t.integer  "away_score",             :null => false
    t.string   "home_team_abbreviation", :null => false
    t.integer  "home_score",             :null => false
    t.integer  "extra_innings"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "schedules", ["date", "home_team_abbreviation"], :name => "index_schedules_on_date_and_home_team_abbreviation", :unique => true

  create_table "standings", :id => false, :force => true do |t|
    t.integer  "year",                         :null => false
    t.integer  "franchise_id",                 :null => false
    t.string   "league",                       :null => false
    t.string   "division",                     :null => false
    t.integer  "wins",                         :null => false
    t.integer  "losses",                       :null => false
    t.integer  "streak",                       :null => false
    t.string   "playoff_berth"
    t.integer  "playoff_round", :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "standings", ["year", "franchise_id"], :name => "index_standings_on_year_and_franchise_id", :unique => true

  create_table "statistics", :id => false, :force => true do |t|
    t.integer  "year",                           :null => false
    t.integer  "player_id",                      :null => false
    t.integer  "franchise_id",                   :null => false
    t.integer  "playoff_round", :default => 0
    t.integer  "G",             :default => 0
    t.integer  "AB",            :default => 0
    t.integer  "R",             :default => 0
    t.integer  "H",             :default => 0
    t.integer  "RBI",           :default => 0
    t.integer  "D",             :default => 0
    t.integer  "T",             :default => 0
    t.integer  "HR",            :default => 0
    t.integer  "SB",            :default => 0
    t.integer  "CS",            :default => 0
    t.integer  "K",             :default => 0
    t.integer  "BB",            :default => 0
    t.integer  "SF",            :default => 0
    t.integer  "SAC",           :default => 0
    t.integer  "HBP",           :default => 0
    t.integer  "CI",            :default => 0
    t.integer  "W",             :default => 0
    t.integer  "L",             :default => 0
    t.integer  "HO",            :default => 0
    t.integer  "S",             :default => 0
    t.integer  "BS",            :default => 0
    t.decimal  "IP",            :default => 0.0
    t.integer  "HA",            :default => 0
    t.integer  "RA",            :default => 0
    t.integer  "ER",            :default => 0
    t.integer  "BBA",           :default => 0
    t.integer  "KA",            :default => 0
    t.integer  "HB",            :default => 0
    t.integer  "WP",            :default => 0
    t.integer  "PB",            :default => 0
    t.integer  "BK",            :default => 0
    t.integer  "E",             :default => 0
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "statistics", ["year", "player_id", "franchise_id", "playoff_round"], :name => "index_statistics", :unique => true

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
