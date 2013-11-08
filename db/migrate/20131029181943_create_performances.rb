class CreatePerformances < ActiveRecord::Migration
  def change
    create_table :performances do |t|
      t.integer :year
      t.integer :franchise_id
      t.string :league
      t.string :division
      t.integer :wins
      t.integer :losses
      t.integer :streak
      t.string :playoff_berth
      t.string :playoff_depth

      t.timestamps
    end
  end
end
