class AddColumnsToGames < ActiveRecord::Migration
  def change
    add_column :games, :played_against, :string
    add_column :games, :sacrifice_fly, :integer, :default => 0
    add_column :games, :sacrifice, :integer, :default => 0
    add_column :games, :hit_by_pitch, :integer, :default => 0
    add_column :games, :hit_batter, :integer, :default => 0
    add_column :games, :wild_pitch, :integer, :default => 0
    add_column :games, :passed_ball, :integer, :default => 0
  end
end
