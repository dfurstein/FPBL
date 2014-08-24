#
class Boxscore < ActiveRecord::Base
  attr_accessible :date, :player_id, :franchise_id, :franchise_id_home,
                  :franchise_id_away, :position, :AB, :R, :H, :RBI, :D, :T, :HR,
                  :SB, :CS, :K, :BB, :SF, :SAC, :HBP, :W, :L, :H, :S, :BS, :IP,
                  :HA, :RA, :ER, :BBA, :KA, :HB, :WP, :PB, :BK, :E
end
