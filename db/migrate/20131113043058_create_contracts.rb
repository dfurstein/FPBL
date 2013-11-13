class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.integer :player_id, null: false
      t.integer :franchise_id, null: false
      t.integer :year, null: false
      t.decimal :salary, precision: 3, scale: 1, null: false
      t.boolean :release, null: false

      t.timestamps
    end
  end
end
