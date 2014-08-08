# Migration to create player information
class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players, id: false do |t|
      t.integer :player_id, null: false
      t.integer :year, null: false
      t.string :dmb_name, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :position, null: false
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :players, [:year, :player_id], unique: true
  end
end
