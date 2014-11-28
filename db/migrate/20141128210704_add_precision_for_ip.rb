class AddPrecisionForIp < ActiveRecord::Migration
  def up
    change_column :boxscores, :IP, :decimal, precision: 4, scale: 1
    change_column :statistics, :IP, :decimal, precision: 4, scale: 1
  end
end
