class ChangeFranchiseIdInSchedules < ActiveRecord::Migration
  def up
    change_column :schedules, :franchise_id_home, :integer
    change_column :schedules, :franchise_id_away, :integer
  end

  def down
    change_column :schedules, :franchise_id_home, :text
    change_column :schedules, :franchise_id_away, :text
  end
end
