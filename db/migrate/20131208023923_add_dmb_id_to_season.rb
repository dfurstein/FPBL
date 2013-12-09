class AddDmbIdToSeason < ActiveRecord::Migration
  def change
    add_column :seasons, :dmb_id, :integer
  end
end
