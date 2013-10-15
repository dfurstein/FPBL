class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :location
      t.string :nickname
      t.string :abbreviation

      t.timestamps
    end
  end
end
