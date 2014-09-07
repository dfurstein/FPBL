class Statistic < ActiveRecord::Base
  self.primary_keys = :year, :player_id, :franchise_id, :playoff_round

  attr_accessible :year, :player_id, :franchise_id, :playoff_round, :G, :AB, :R,
                  :H, :RBI, :D, :T, :HR, :SB, :CS, :K, :BB, :SF, :SAC, :HBP,
                  :CI, :W, :L, :HO, :S, :BS, :IP, :HA, :RA, :ER, :BBA, :KA, :HB,
                  :WP, :PB, :BK, :E

  belongs_to :player,  foreign_key: [:year, :player_id]

  def self.update(boxscore, playoff_round)
    statistic =
      find_or_create_by_year_and_player_id_and_franchise_id_and_playoff_round(
        boxscore.date.year, boxscore.player_id, boxscore.franchise_id,
        playoff_round)

    statistic.G += 1
    statistic.AB += boxscore.AB
    statistic.R += boxscore.R
    statistic.H += boxscore.H
    statistic.RBI += boxscore.RBI
    statistic.D += boxscore.D
    statistic.T += boxscore.T
    statistic.HR += boxscore.HR
    statistic.SB += boxscore.SB
    statistic.CS += boxscore.CS
    statistic.K += boxscore.K
    statistic.BB += boxscore.BB
    statistic.SF += boxscore.SF
    statistic.SAC += boxscore.SAC
    statistic.HBP += boxscore.HBP
    statistic.CI += boxscore.CI
    statistic.W += boxscore.W
    statistic.L += boxscore.L
    statistic.HO += boxscore.HO
    statistic.S += boxscore.S
    statistic.BS += boxscore.BS
    statistic.IP += boxscore.IP
    statistic.HA += boxscore.HA
    statistic.RA += boxscore.RA
    statistic.ER += boxscore.ER
    statistic.BBA += boxscore.BBA
    statistic.KA += boxscore.KA
    statistic.HB += boxscore.HB
    statistic.WP += boxscore.WP
    statistic.PB += boxscore.PB
    statistic.BK += boxscore.BK
    statistic.E += boxscore.E

    statistic.save
  end

  def self.hitters(year, franchise_id, playoff_round)
    where(year: year, franchise_id: franchise_id, playoff_round: playoff_round)
      .select { |statistic| statistic.PA > 0 && statistic.player.hitter? }
  end

  def self.pitchers_as_hitters(year, franchise_id, playoff_round)
    ignore = %w(year player_id franchise_id HO S BS IP HA RA ER BBA KA HB
                WP PB BK created_at updated_at)

    new(where(year: year, franchise_id: franchise_id,
              playoff_round: playoff_round)
      .select { |statistic| statistic.player.pitcher? }
      .map(&:attributes)
      .each_with_object({}) do |hash, result|
        hash.each do |key, value|
          (result[key] = (result[key] || 0) + value) unless ignore.include?(key)
        end; result
      end)
  end

  def self.hitting_totals(year, franchise_id, playoff_round)
    ignore = %w(year player_id franchise_id HO S BS IP HA RA ER BBA KA HB
                WP PB BK created_at updated_at)

    new(where(year: year, franchise_id: franchise_id,
              playoff_round: playoff_round)
      .map(&:attributes)
      .each_with_object({}) do |hash, result|
        hash.each do |key, value|
          (result[key] = (result[key] || 0) + value) unless ignore.include?(key)
        end; result
      end)
  end

  def self.pitchers(year, franchise_id, playoff_round)
    where(year: year, franchise_id: franchise_id, playoff_round: playoff_round)
      .select { |statistic| statistic.IP > 0 && statistic.player.pitcher? }
  end

  def self.pitching_totals(year, franchise_id, playoff_round)
    ignore = %w(year player_id franchise_id AB R H RBI D T HR SB CS K BB SF
                SAC HBP CI created_at updated_at)

    new(where(year: year, franchise_id: franchise_id,
              playoff_round: playoff_round)
      .map(&:attributes)
      .each_with_object({}) do |hash, result|
        hash.each do |key, value|
          (result[key] = (result[key] || 0) + value) unless ignore.include?(key)
        end; result
      end)
  end

  def PA
    self.AB + self.BB + self.HBP + self.SF + self.SAC + self.CI
  end

  def AVG
    self.H / self.AB.to_f
  end

  def OBP
    (self.H + self.BB + self.HBP) /
    (self.AB + self.BB + self.HBP + self.SF).to_f
  end

  def SLG
    (self.H + self.D + (self.T * 2) + (self.HR * 3)) / self.AB.to_f
  end

  def OPS
    self.OBP + self.SLG
  end

  def BBPct
    self.BB / self.PA.to_f * 100.0
  end

  def KPct
    self.K / self.PA.to_f * 100.0
  end

  def ISO
    self.SLG - self.AVG.to_f
  end

  def BABIP
    (self.H - self.HR) /  (self.AB - self.K - self.HR + self.SF).to_f
  end

  def WHIP
    (self.HA + self.BBA) / self.IP
  end

  def ERA
    (self.ER / self.IP) * 9
  end
end
