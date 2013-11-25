class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.date :date, null: false
      t.string :road_team, null: false
      t.integer :road_score, null: false
      t.string :home_team, null: false
      t.integer :home_score, null: false
      t.integer :extra_innings

      t.timestamps
    end

    add_index :schedules, [:date, :home_team], :unique => true
  end
end
