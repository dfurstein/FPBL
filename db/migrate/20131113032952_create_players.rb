class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :dmb_id, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :position, null: false

      t.timestamps
    end
  end
end
