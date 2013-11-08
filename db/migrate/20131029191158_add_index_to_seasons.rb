class AddIndexToSeasons < ActiveRecord::Migration
  def change
    add_index :seasons, [:year, :franchise_id], :unique => true
  end
end
