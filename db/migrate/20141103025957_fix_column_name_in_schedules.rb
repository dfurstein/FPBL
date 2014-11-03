class FixColumnNameInSchedules < ActiveRecord::Migration
  def change
    change_table :schedules do |t|
      t.rename :home_team_id, :franchise_id_home
      t.rename :away_team_id, :franchise_id_away
    end
  end
end
