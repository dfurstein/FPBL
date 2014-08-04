class Boxscore < ActiveRecord::Base
  attr_accessible :allowed_earned_run, :allowed_hit, :allowed_run, :allowed_strike_out, :allowed_walk, :at_bat, :blown_save, :caught_stealing, :date, :double, :error, :hit, :hold, :homerun, :inning, :loss, :dmb_id, :position, :run, :run_batted_in, :save_game, :steal, :strike_out, :team, :triple, :walk, :win, :played_against, :sacrifice_fly, :sacrifice, :hit_by_pitch, :hit_batter, :wild_pitch, :passed_ball, :balk, :home_or_away

  def date=(val)
    self[:date] = val
  end

  def team=(val)
    self[:team] = val
  end

  def home_or_away=(val)
    self[:home_or_away] = val
  end

  def dmb_id=(val)
    self[:dmb_id] = val
  end

  def position=(val)
    self[:position] = val.upcase
  end

  def at_bat=(val)
    self[:at_bat] = val
  end

  def run=(val)
    self[:run] = val
  end

  def hit=(val)
    self[:hit] = val
  end

  def run_batted_in=(val)
    self[:run_batted_in] = val
  end

  def win=(val)
    self[:win] = val
  end

  def loss=(val)
    self[:loss] = val
  end

  def hold=(val)
    self[:hold] = val
  end

  def save_game=(val)
    self[:save_game] = val
  end

  def blown_save=(val)
    self[:blown_save] = val
  end

  def inning=(val)
    self[:inning] = val
  end

  def allowed_hit=(val)
    self[:allowed_hit] = val
  end

  def allowed_run=(val)
    self[:allowed_run] = val
  end

  def allowed_earned_run=(val)
    self[:allowed_earned_run] = val
  end

  def allowed_walk=(val)
    self[:allowed_walk] = val
  end

  def strike_out_allowed=(val)
    self[:allowed_strike_out] = val
  end

  def error=(val)
    self[:error] = val
  end

  def double=(val)
    self[:double] = val
  end

  def triple=(val)
    self[:triple] = val
  end

  def homerun=(val)
    self[:homerun] = val
  end

  def steal=(val)
    self[:steal] = val
  end

  def caught_stealing=(val)
    self[:caught_stealing] = val
  end

  def strike_out=(val)
    self[:strike_out] = val
  end

  def walk=(val)
    self[:walk] = val
  end

  def played_against=(val)
    self[:played_against] = val
  end

  def sacrifice_fly=(val)
    self[:sacrifice_fly] = val
  end

  def sacrifice=(val)
    self[:sacrifice] = val
  end

  def hit_by_pitch=(val)
    self[:hit_by_pitch] = val
  end

  def hit_batter=(val)
    self[:hit_batter] = val
  end

  def wild_pitch=(val)
    self[:wild_pitch] = val
  end

  def passed_ball=(val)
    self[:passed_ball] = val
  end

  def balk=(val)
    self[:balk] = val
  end
end
