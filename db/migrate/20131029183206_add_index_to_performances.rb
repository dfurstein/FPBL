class AddIndexToPerformances < ActiveRecord::Migration
  def change
    add_index :performances, [:year, :franchise_id], :unique => true
  end
end
