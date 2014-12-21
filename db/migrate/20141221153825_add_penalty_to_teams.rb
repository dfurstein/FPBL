class AddPenaltyToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :penalty, :integer, default: 0
  end
end
