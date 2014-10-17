class Transactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :transaction_group_id, null: false
      t.string :transaction_type, null: false
      t.integer :year
      t.integer :franchise_id_to
      t.integer :franchise_id_from
      t.integer :player_id
      t.integer :extension_year
      t.integer :draft_year
      t.integer :draft_round
      t.integer :draft_franchise_id_original
      t.datetime :processed_at

      t.timestamps
    end
  end
end
