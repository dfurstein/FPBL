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

ActiveRecord::Schema.define(:version => 20160418012813) do

  create_table "boxscores", :id => false, :force => true do |t|
    t.date     "date",                             :null => false
    t.integer  "player_id",                        :null => false
    t.integer  "franchise_id",                     :null => false
    t.integer  "franchise_id_home",                :null => false
    t.integer  "franchise_id_away",                :null => false
    t.string   "position",                         :null => false
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
    t.integer  "outs",              :default => 0
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
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
  end

  add_index "boxscores", ["date", "player_id"], :name => "index_boxscores_on_date_and_player_id", :unique => true

  create_table "contracts", :id => false, :force => true do |t|
    t.integer  "player_id",                                                     :null => false
    t.integer  "franchise_id",                                                  :null => false
    t.integer  "year",                                                          :null => false
    t.decimal  "salary",       :precision => 4, :scale => 2,                    :null => false
    t.boolean  "released",                                   :default => false, :null => false
    t.datetime "created_at",                                                    :null => false
    t.datetime "updated_at",                                                    :null => false
  end

  add_index "contracts", ["year", "player_id", "franchise_id"], :name => "index_contracts_on_year_and_player_id_and_franchise_id", :unique => true

  create_table "draft_rights", :id => false, :force => true do |t|
    t.integer  "year",                  :null => false
    t.integer  "round",                 :null => false
    t.integer  "franchise_id_original", :null => false
    t.integer  "franchise_id_current",  :null => false
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
  end

  add_index "draft_rights", ["year", "round", "franchise_id_original"], :name => "index_draft_rights_on_year_and_round_and_franchise_id_original", :unique => true

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

  create_table "forem_categories", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "slug"
  end

  add_index "forem_categories", ["slug"], :name => "index_forem_categories_on_slug", :unique => true

  create_table "forem_forums", :force => true do |t|
    t.string  "name"
    t.text    "description"
    t.integer "category_id"
    t.integer "views_count", :default => 0
    t.string  "slug"
  end

  add_index "forem_forums", ["slug"], :name => "index_forem_forums_on_slug", :unique => true

  create_table "forem_groups", :force => true do |t|
    t.string "name"
  end

  add_index "forem_groups", ["name"], :name => "index_forem_groups_on_name"

  create_table "forem_memberships", :force => true do |t|
    t.integer "group_id"
    t.integer "member_id"
  end

  add_index "forem_memberships", ["group_id"], :name => "index_forem_memberships_on_group_id"

  create_table "forem_moderator_groups", :force => true do |t|
    t.integer "forum_id"
    t.integer "group_id"
  end

  add_index "forem_moderator_groups", ["forum_id"], :name => "index_forem_moderator_groups_on_forum_id"

  create_table "forem_posts", :force => true do |t|
    t.integer  "topic_id"
    t.text     "text"
    t.integer  "user_id"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "reply_to_id"
    t.string   "state",       :default => "pending_review"
    t.boolean  "notified",    :default => false
  end

  add_index "forem_posts", ["reply_to_id"], :name => "index_forem_posts_on_reply_to_id"
  add_index "forem_posts", ["state"], :name => "index_forem_posts_on_state"
  add_index "forem_posts", ["topic_id"], :name => "index_forem_posts_on_topic_id"
  add_index "forem_posts", ["user_id"], :name => "index_forem_posts_on_user_id"

  create_table "forem_subscriptions", :force => true do |t|
    t.integer "subscriber_id"
    t.integer "topic_id"
  end

  create_table "forem_topics", :force => true do |t|
    t.integer  "forum_id"
    t.integer  "user_id"
    t.string   "subject"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.boolean  "locked",       :default => false,            :null => false
    t.boolean  "pinned",       :default => false
    t.boolean  "hidden",       :default => false
    t.datetime "last_post_at"
    t.string   "state",        :default => "pending_review"
    t.integer  "views_count",  :default => 0
    t.string   "slug"
  end

  add_index "forem_topics", ["forum_id"], :name => "index_forem_topics_on_forum_id"
  add_index "forem_topics", ["slug"], :name => "index_forem_topics_on_slug", :unique => true
  add_index "forem_topics", ["state"], :name => "index_forem_topics_on_state"
  add_index "forem_topics", ["user_id"], :name => "index_forem_topics_on_user_id"

  create_table "forem_views", :force => true do |t|
    t.integer  "user_id"
    t.integer  "viewable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "count",             :default => 0
    t.string   "viewable_type"
    t.datetime "current_viewed_at"
    t.datetime "past_viewed_at"
  end

  add_index "forem_views", ["updated_at"], :name => "index_forem_views_on_updated_at"
  add_index "forem_views", ["user_id"], :name => "index_forem_views_on_user_id"
  add_index "forem_views", ["viewable_id"], :name => "index_forem_views_on_topic_id"

  create_table "owners", :force => true do |t|
    t.string   "first_name",                                           :null => false
    t.string   "last_name",                                            :null => false
    t.string   "email",                  :default => ""
    t.datetime "created_at",                                           :null => false
    t.datetime "updated_at",                                           :null => false
    t.string   "encrypted_password",     :default => "",               :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,                :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.boolean  "forem_admin",            :default => false
    t.string   "forem_state",            :default => "pending_review"
    t.boolean  "forem_auto_subscribe",   :default => false
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

  create_table "rankings", :id => false, :force => true do |t|
    t.date     "date"
    t.integer  "franchise_id"
    t.decimal  "ranking",      :precision => 8, :scale => 4
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  add_index "rankings", ["date", "franchise_id"], :name => "index_rankings_on_date_and_franchise_id", :unique => true

  create_table "schedules", :force => true do |t|
    t.date     "date",                                                            :null => false
    t.integer  "franchise_id_away"
    t.integer  "score_away",                                       :default => 0
    t.integer  "franchise_id_home",                                               :null => false
    t.integer  "score_home",                                       :default => 0
    t.integer  "outs",                                             :default => 0
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
    t.decimal  "elo_away",          :precision => 10, :scale => 5
    t.decimal  "elo_home",          :precision => 10, :scale => 5
  end

  add_index "schedules", ["date", "franchise_id_home"], :name => "index_schedules_on_date_and_franchise_id_home", :unique => true

  create_table "standings", :id => false, :force => true do |t|
    t.integer  "year",                          :null => false
    t.integer  "franchise_id",                  :null => false
    t.string   "league",        :default => "", :null => false
    t.string   "division",      :default => "", :null => false
    t.integer  "wins",          :default => 0,  :null => false
    t.integer  "losses",        :default => 0,  :null => false
    t.integer  "streak",        :default => 0,  :null => false
    t.string   "playoff_berth"
    t.integer  "playoff_round", :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "standings", ["year", "franchise_id"], :name => "index_standings_on_year_and_franchise_id", :unique => true

  create_table "statistics", :id => false, :force => true do |t|
    t.integer  "year",                         :null => false
    t.integer  "player_id",                    :null => false
    t.integer  "franchise_id",                 :null => false
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
    t.integer  "outs",          :default => 0
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
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "statistics", ["year", "player_id", "franchise_id", "playoff_round"], :name => "index_statistics", :unique => true

  create_table "teams", :id => false, :force => true do |t|
    t.integer "franchise_id",                                              :null => false
    t.integer "year",                                                      :null => false
    t.string  "city",                                                      :null => false
    t.string  "nickname",                                                  :null => false
    t.string  "abbreviation",                                              :null => false
    t.string  "stadium"
    t.integer "owner_id",                                                  :null => false
    t.decimal "salary_cap",   :precision => 3, :scale => 1
    t.integer "dmb_id"
    t.integer "penalty",                                    :default => 0
  end

  add_index "teams", ["year", "franchise_id"], :name => "index_teams_on_year_and_franchise_id", :unique => true

  create_table "transactions", :force => true do |t|
    t.integer  "transaction_group_id",        :null => false
    t.string   "transaction_type",            :null => false
    t.integer  "year"
    t.integer  "franchise_id_to"
    t.integer  "franchise_id_from"
    t.integer  "player_id"
    t.integer  "extension_year"
    t.integer  "draft_year"
    t.integer  "draft_round"
    t.integer  "draft_franchise_id_original"
    t.datetime "processed_at"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

end
