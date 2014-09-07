# Model representing the aggregate of the boxscores for each season
class CreateStatistics < ActiveRecord::Migration
  def change
    create_table :statistics, id: false do |t|
      t.integer :year, null: false
      t.integer :player_id, null: false
      t.integer :franchise_id, null: false
      t.integer :playoff_round, default: 0
      t.integer :G, default: 0
      t.integer :AB, default: 0
      t.integer :R, default: 0
      t.integer :H, default: 0
      t.integer :RBI, default: 0
      t.integer :D, default: 0
      t.integer :T, default: 0
      t.integer :HR, default: 0
      t.integer :SB, default: 0
      t.integer :CS, default: 0
      t.integer :K, default: 0
      t.integer :BB, default: 0
      t.integer :SF, default: 0
      t.integer :SAC, default: 0
      t.integer :HBP, default: 0
      t.integer :CI, default: 0
      t.integer :W, default: 0
      t.integer :L, default: 0
      t.integer :HO, default: 0
      t.integer :S, default: 0
      t.integer :BS, default: 0
      t.decimal :IP, default: 0
      t.integer :HA, default: 0
      t.integer :RA, default: 0
      t.integer :ER, default: 0
      t.integer :BBA, default: 0
      t.integer :KA, default: 0
      t.integer :HB, default: 0
      t.integer :WP, default: 0
      t.integer :PB, default: 0
      t.integer :BK, default: 0
      t.integer :E, default: 0

      t.timestamps
    end

    add_index :statistics, [:year, :player_id, :franchise_id, :playoff_round],
              unique: true, name: 'index_statistics'
  end
end
