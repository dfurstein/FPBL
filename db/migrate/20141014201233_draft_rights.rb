#Model of who owns what draft picks in an upcoming draft
class DraftRights < ActiveRecord::Migration
  def change
    create_table :draft_rights, id: false do |t|
      t.integer :year, null: false
      t.integer :round, null: false
      t.integer :franchise_id_original, null: false
      t.integer :franchise_id_current, null: false

      t.timestamps
    end

    add_index :draft_rights, [:year, :round, :franchise_id_original],
              unique: true
  end
end
