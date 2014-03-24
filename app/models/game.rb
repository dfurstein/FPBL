class Game < ActiveRecord::Base
  attr_accessible :allowed_earned_run, :allowed_hit, :allowed_run, :allowed_strike_out, :allowed_walk, :at_bat, :blown_save, :caught_stealing, :date, :double, :error, :hit, :hold, :homerun, :inning, :loss, :name, :position, :run, :run_batted_in, :save, :steal, :strike_out, :team, :triple, :walk, :win
end
