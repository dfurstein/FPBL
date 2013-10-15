class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.integer :year
      t.integer :franchise_id
      t.integer :team_id
      t.integer :owner_id

      t.timestamps
    end
  end
end
