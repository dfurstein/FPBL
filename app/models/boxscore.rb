#
class Boxscore < ActiveRecord::Base
  self.primary_keys = :date, :player_id

  attr_accessible :date, :player_id, :franchise_id, :franchise_id_home,
                  :franchise_id_away, :position, :AB, :R, :H, :RBI, :D, :T, :HR,
                  :SB, :CS, :K, :BB, :SF, :SAC, :HBP, :CI, :W, :L, :HO, :S, :BS,
                  :IP, :HA, :RA, :ER, :BBA, :KA, :HB, :WP, :PB, :BK, :E

  def self.player_totals(year, player_id, franchise_id)
    Boxscore.where(date: Date.new(year, 04 , 01)..Date.new(year, 9, 30),
                   player_id: player_id, franchise_id: franchise_id)
      .select('player_id, sum(AB) as AB, sum(R) as R, sum(H) as H,
              sum(RBI) as RBI, sum(D) as D , sum(T) as T, sum(HR) as HR,
              sum(SB) as SB, sum(CS) as CS, sum(K) as K, sum(BB) as BB,
              sum(SF) as SF, sum(SAC) as SAC, sum(HBP) as HBP, sum(W) as W,
              sum(L) as L, sum(HO) as HO, sum(S) as S, sum(BS) as BS,
              sum(IP) as IP, sum(HA) as HA, sum(RA) as RA, sum(ER) as ER,
              sum(BBA) as BBA, sum(KA) as KA, sum(HB) as HB, sum(WP) as WP,
              sum(PB) as PB, sum(BK) as BK, sum(E) as E')
  end
end
