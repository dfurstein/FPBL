#
class Boxscore < ActiveRecord::Base
  self.primary_keys = :date, :player_id

  attr_accessible :date, :player_id, :franchise_id, :franchise_id_home,
                  :franchise_id_away, :position, :AB, :R, :H, :RBI, :D, :T, :HR,
                  :SB, :CS, :K, :BB, :SF, :SAC, :HBP, :CI, :W, :L, :HO, :S, :BS,
                  :IP, :HA, :RA, :ER, :BBA, :KA, :HB, :WP, :PB, :BK, :E

  def year
    date.year
  end
end
