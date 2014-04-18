class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.date :date, null: false
      t.string :dmb_id, null: false
      t.string :team, null: false
      t.string :position, null: false
      t.string :played_against, null: false
      t.string :home_or_away, null: false
      t.integer :at_bat, default: 0
      t.integer :run, default: 0
      t.integer :hit, default: 0
      t.integer :run_batted_in, default: 0
      t.integer :double, default: 0
      t.integer :triple, default: 0
      t.integer :homerun, default: 0
      t.integer :steal, default: 0
      t.integer :caught_stealing, default: 0
      t.integer :strike_out, default: 0
      t.integer :walk, default: 0
      t.integer :sacrifice_fly, default: 0
      t.integer :sacrifice, default: 0
      t.integer :hit_by_pitch, default: 0
      t.integer :win, default: 0
      t.integer :loss, default: 0
      t.integer :hold, default: 0
      t.integer :save_game, default: 0
      t.integer :blown_save, default: 0
      t.decimal :inning, default: 0
      t.integer :allowed_hit, default: 0
      t.integer :allowed_run, default: 0
      t.integer :allowed_earned_run, default: 0
      t.integer :allowed_walk, default: 0
      t.integer :allowed_strike_out, default: 0
      t.integer :hit_batter, default: 0
      t.integer :wild_pitch, default: 0
      t.integer :passed_ball, default: 0
      t.integer :balk, default: 0
      t.integer :error, default: 0

      t.timestamps
    end

    add_index :games, [:date, :dmb_id], :unique => true
  end
end
