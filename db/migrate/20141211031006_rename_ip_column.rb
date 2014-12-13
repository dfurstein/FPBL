class RenameIpColumn < ActiveRecord::Migration
  def up
    change_column :boxscores, :IP, :integer, default: 0
    change_column :statistics, :IP, :integer, default: 0
    change_column :schedules, :IP, :integer, default: 0

    rename_column :boxscores, :IP, :outs
    rename_column :statistics, :IP, :outs
    rename_column :schedules, :IP, :outs
  end
end
