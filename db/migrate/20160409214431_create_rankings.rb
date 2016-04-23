class CreateRankings < ActiveRecord::Migration
  def change
    create_table :rankings, id: false do |t|
      t.date :date
      t.integer :franchise_id
      t.decimal :ranking, precision: 8, scale: 4

      t.timestamps
    end

    add_index :rankings, [:date, :franchise_id], unique: true
  end
end
