# Migration script to create teams
class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams, id: false do |t|
      t.integer :franchise_id, null: false
      t.integer :year, null: false
      t.string :city, null: false
      t.string :nickname, null: false
      t.string :abbreviation, null: false
      t.string :stadium
      t.integer :owner_id, null: false
      t.decimal :salary_cap, precision: 3, scale: 1
      t.integer :dmb_id
    end

    add_index :teams, [:year, :franchise_id], unique: true
  end
end
