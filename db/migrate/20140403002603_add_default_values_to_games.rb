class AddDefaultValuesToGames < ActiveRecord::Migration
  def change
    change_column :games, :hit, :integer, :default => 0
    change_column :games, :at_bat, :integer, :default => 0
    change_column :games, :run, :integer, :default => 0
    change_column :games, :run_batted_in, :integer, :default => 0
    change_column :games, :double, :integer, :default => 0
    change_column :games, :triple, :integer, :default => 0
    change_column :games, :homerun, :integer, :default => 0
    change_column :games, :steal, :integer, :default => 0
    change_column :games, :caught_stealing, :integer, :default => 0
    change_column :games, :strike_out, :integer, :default => 0
    change_column :games, :walk, :integer, :default => 0
    change_column :games, :win, :integer, :default => 0
    change_column :games, :loss, :integer, :default => 0
    change_column :games, :hold, :integer, :default => 0
    change_column :games, :save_game, :integer, :default => 0
    change_column :games, :blown_save, :integer, :default => 0
    change_column :games, :inning, :integer, :default => 0.0
    change_column :games, :allowed_hit, :integer, :default => 0
    change_column :games, :allowed_run, :integer, :default => 0
    change_column :games, :allowed_earned_run, :integer, :default => 0
    change_column :games, :allowed_walk, :integer, :default => 0
    change_column :games, :allowed_strike_out, :integer, :default => 0
    change_column :games, :error, :integer, :default => 0
  end
end
