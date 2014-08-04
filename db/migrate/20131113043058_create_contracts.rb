# Migration to create player contracts
class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.integer :player_id, null: false
      t.integer :franchise_id, null: false
      t.integer :year, null: false
      t.decimal :salary, precision: 3, scale: 1, null: false
      t.boolean :released, null: false, default: false

      t.timestamps
    end

    add_index :contracts, [:year, :player_id, :franchise_id], unique: true
  end
end
