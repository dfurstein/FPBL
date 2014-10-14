# Model representing the history of the draft
class CreateDrafts < ActiveRecord::Migration
  def change
    create_table :drafts, id: false do |t|
      t.integer :year, null: false
      t.integer :round, null: false
      t.integer :selection, null: false
      t.integer :franchise_id_original
      t.integer :franchise_id_current
      t.integer :player_id

      t.timestamps
    end

    add_index :drafts, [:year, :round, :selection], unique: true
  end
end
