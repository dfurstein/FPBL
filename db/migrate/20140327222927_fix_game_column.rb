class FixGameColumn < ActiveRecord::Migration
  def change
    rename_column :games, :save, :save_game
  end
end
