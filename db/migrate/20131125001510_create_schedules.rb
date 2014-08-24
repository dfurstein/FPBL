# Migration to create schedule
class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.date :date, null: false
      t.string :away_team_abbreviation, null: false
      t.integer :away_score, null: false
      t.string :home_team_abbreviation, null: false
      t.integer :home_score, null: false
      t.integer :extra_innings

      t.timestamps
    end

    add_index :schedules, [:date, :home_team_abbreviation], unique: true
  end
end
