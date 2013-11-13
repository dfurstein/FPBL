class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.integer :year, null: false
      t.integer :franchise_id, null: false
      t.integer :team_id, null: false
      t.integer :owner_id, null: false

      t.timestamps
    end
  end
end
