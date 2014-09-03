class Statistic < ActiveRecord::Base
  self.primary_keys = :year, :player_id, :franchise_id

  attr_accessible :year, :player_id, :franchise_id, :G, :AB, :R, :H, :RBI, :D,
                  :T, :HR, :SB, :CS, :K, :BB, :SF, :SAC, :HBP, :CI, :W, :L, :HO,
                  :S, :BS, :IP, :HA, :RA, :ER, :BBA, :KA, :HB, :WP, :PB, :BK, :E

  belongs_to :player,  foreign_key: [:year, :player_id]

  def self.update(boxscore)
    stat = Statistic.find_or_create_by_year_and_player_id_and_franchise_id(
      boxscore.date.year, boxscore.player_id, boxscore.franchise_id)

    stat.G += 1
    stat.AB += boxscore.AB
    stat.R += boxscore.R
    stat.H += boxscore.H
    stat.RBI += boxscore.RBI
    stat.D += boxscore.D
    stat.T += boxscore.T
    stat.HR += boxscore.HR
    stat.SB += boxscore.SB
    stat.CS += boxscore.CS
    stat.K += boxscore.K
    stat.BB += boxscore.BB
    stat.SF += boxscore.SF
    stat.SAC += boxscore.SAC
    stat.HBP += boxscore.HBP
    stat.CI += boxscore.CI
    stat.W += boxscore.W
    stat.L += boxscore.L
    stat.HO += boxscore.HO
    stat.S += boxscore.S
    stat.BS += boxscore.BS
    stat.IP += boxscore.IP
    stat.HA += boxscore.HA
    stat.RA += boxscore.RA
    stat.ER += boxscore.ER
    stat.BBA += boxscore.BBA
    stat.KA += boxscore.KA
    stat.HB += boxscore.HB
    stat.WP += boxscore.WP
    stat.PB += boxscore.PB
    stat.BK += boxscore.BK
    stat.E += boxscore.E

    stat.save
  end

  def self.hitters(year, franchise_id)
    where(year: year, franchise_id: franchise_id)
      .select { |statistic| statistic.PA > 0 && statistic.player.hitter? }
  end

  def self.pitchers_as_hitters(year, franchise_id)
    ignore = %w(year player_id franchise_id HO S BS IP HA RA ER BBA KA HB
                WP PB BK created_at updated_at)

    new(where(year: year, franchise_id: franchise_id)
      .select { |statistic| statistic.player.pitcher? }
      .map(&:attributes)
      .each_with_object({}) do |hash, result|
        puts hash['W']
        hash.each do |key, value|
          (result[key] = (result[key] || 0) + value) unless ignore.include?(key)
        end; result
      end)
  end

  def self.pitchers(year, franchise_id)
    where(year: year, franchise_id: franchise_id)
      .select { |statistic| statistic.IP > 0 && statistic.player.pitcher? }
  end

  def PA
    self.AB + self.BB + self.HBP + self.SF + self.SAC + self.CI
  end

  def AVG
    self.H / self.AB.to_f
  end

  def OBP
    (self.H + self.BB + self.HBP) / (self.AB + self.BB + self.HBP + self.SF).to_f
  end

  def SLG
    (self.H + self.D + (self.T * 2) + (self.HR * 3)) / self.AB.to_f
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
