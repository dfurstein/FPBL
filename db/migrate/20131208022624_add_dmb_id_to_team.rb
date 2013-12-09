class AddDmbIdToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :dmb_id, :integer
  end
end
