#
class Boxscore < ActiveRecord::Base
  self.primary_keys = :date, :player_id

  attr_accessible :date, :player_id, :franchise_id, :franchise_id_home,
                  :franchise_id_away, :position, :AB, :R, :H, :RBI, :D, :T, :HR,
                  :SB, :CS, :K, :BB, :SF, :SAC, :HBP, :CI, :W, :L, :HO, :S, :BS,
                  :outs, :HA, :RA, :ER, :BBA, :KA, :HB, :WP, :PB, :BK, :E

  def year
    date.year
  end

  def game_score
    50 + outs + (outs - 12 > 4 ? ((outs / 3 - 4) * 2) : 0) + self.KA -
      (2 * self.HA) - (4 * self.ER) - (2 * (self.RA - self.ER)) - self.BBA
  end

  def espn_score
    59 + self.H + self.R + (0.25 * self.BB) + (0.25 + self.HBP) +
      (3 * self.HR) + (2 * self.T) + self.D + self.H + (0.25 * self.SB) -
      (0.25 * self.CS) + (0.25 * self.SF) + (0.25 * self.SAC) + self.RBI -
      (0.25 * self.K) - (0.25 * (self.AB - self.H))
  end

  def cycle?
    self.H - self.D - self.T - self.HR > 0 &&
      self.D > 0 && self.T > 0 && self.HR > 0
  end
end
