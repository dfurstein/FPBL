class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :location, null: false
      t.string :nickname, null: false
      t.string :abbreviation, null: false

      t.timestamps
    end
  end
end
