class Game < ActiveRecord::Base
  attr_accessible :allowed_earned_run, :allowed_hit, :allowed_run, :allowed_strike_out, :allowed_walk, :at_bat, :blown_save, :caught_stealing, :date, :double, :error, :hit, :hold, :homerun, :inning, :loss, :dmb_id, :position, :run, :run_batted_in, :save_game, :steal, :strike_out, :team, :triple, :walk, :win

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
end
