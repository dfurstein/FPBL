class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.date :date, null: false
      t.string :dmb_id, null: false
      t.string :team, null: false
      t.string :position, null: false
      t.integer :at_bat
      t.integer :run
      t.integer :hit
      t.integer :run_batted_in
      t.integer :double
      t.integer :triple
      t.integer :homerun
      t.integer :steal
      t.integer :caught_stealing
      t.integer :strike_out
      t.integer :walk
      t.boolean :win
      t.boolean :loss
      t.boolean :hold
      t.boolean :save
      t.boolean :blown_save
      t.decimal :inning
      t.integer :allowed_hit
      t.integer :allowed_run
      t.integer :allowed_earned_run
      t.integer :allowed_walk
      t.integer :allowed_strike_out
      t.integer :error

      t.timestamps
    end
  
  add_index :games, [:date, :dmb_id], :unique => true
  end
end
