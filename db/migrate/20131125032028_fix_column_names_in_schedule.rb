class FixColumnNamesInSchedule < ActiveRecord::Migration
  def change
    rename_column :schedules, :road_team, :away_team
    rename_column :schedules, :road_score, :away_score
  end
end
