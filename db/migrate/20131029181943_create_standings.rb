# Migration to create team record
class CreateStandings < ActiveRecord::Migration
  def change
    create_table :standings, id: false do |t|
      t.integer :year, null: false
      t.integer :franchise_id, null: false
      t.string :league, null: false, default: ''
      t.string :division, null: false, default: ''
      t.integer :wins, null: false, default: 0
      t.integer :losses, null: false, default: 0
      t.integer :streak, null: false, default: 0
      t.string :playoff_berth
      t.integer :playoff_round, default: 0

      t.timestamps
    end

    add_index :standings, [:year, :franchise_id], unique: true
  end
end
