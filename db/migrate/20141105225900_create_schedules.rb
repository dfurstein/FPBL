# Migration to create schedule
class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.date :date, null: false
      t.string :franchise_id_away
      t.integer :score_away, default: 0
      t.string :franchise_id_home, null: false
      t.integer :score_home, default: 0
      t.decimal :innings, default: 0

      t.timestamps
    end

    add_index :schedules, [:date, :franchise_id_home], unique: true
  end
end
