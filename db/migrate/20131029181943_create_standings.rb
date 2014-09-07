# Migration to create team record
class CreateStandings < ActiveRecord::Migration
  def change
    create_table :standings, id: false do |t|
      t.integer :year, null: false
      t.integer :franchise_id, null: false
      t.string :league, null: false
      t.string :division, null: false
      t.integer :wins, null: false
      t.integer :losses, null: false
      t.integer :streak, null: false
      t.string :playoff_berth
      t.integer :playoff_round, default: 0

      t.timestamps
    end

    add_index :standings, [:year, :franchise_id], unique: true
  end
end
