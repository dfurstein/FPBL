class CreatePerformances < ActiveRecord::Migration
  def change
    create_table :performances do |t|
      t.integer :year, null: false
      t.integer :franchise_id, null: false
      t.string :league, null: false
      t.string :division, null: false
      t.integer :wins, null: false
      t.integer :losses, null: false
      t.integer :streak, null: false
      t.string :playoff_berth
      t.string :playoff_depth

      t.timestamps
    end
  end
end
