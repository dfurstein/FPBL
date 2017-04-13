class Statistic < ActiveRecord::Base
  self.primary_keys = :year, :player_id, :franchise_id, :playoff_round

  attr_accessible :year, :player_id, :franchise_id, :playoff_round, :G, :AB, :R,
                  :H, :RBI, :D, :T, :HR, :SB, :CS, :K, :BB, :SF, :SAC, :HBP,
                  :CI, :W, :L, :HO, :S, :BS, :outs, :HA, :RA, :ER, :BBA, :KA,
                  :HB, :WP, :PB, :BK, :E

  belongs_to :player,  foreign_key: [:year, :player_id]
  belongs_to :team, foreign_key: [:year, :franchise_id]

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
    statistic.outs += boxscore.outs
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

  def self.all_hitters(year, franchise_id, playoff_round, plate_appearances_threshold)
    all_stats = where(year: year, franchise_id: franchise_id, playoff_round: playoff_round)
      .group_by { |statistic| statistic[:player_id] }

    all_stats.keys.each_with_object({}) { |id, hash| hash[id] = merge(all_stats[id]) }.values
      .select { |statistic| statistic.PA > plate_appearances_threshold && statistic.player.hitter? }
  end

  def self.team_hitters(year, franchise_id, playoff_round)
    self.all_hitters(year, franchise_id, playoff_round, 0)
  end

  def self.team_pitchers_as_hitters(year, franchise_id, playoff_round)
    ignore = %w(year player_id franchise_id HO S BS outs HA RA ER BBA KA HB
                WP PB BK created_at updated_at)

    new(where(year: year, franchise_id: franchise_id,
              playoff_round: playoff_round)
      .select { |statistic| statistic.player.pitcher? }
      .map(&:attributes)
      .each_with_object({}) do |hash, result|
        hash.each do |key, value|
          (result[key] = result.fetch(key, 0) + value) unless ignore.include?(key)
        end; result
      end)
  end

  def self.team_hitting_totals(year, franchise_id, playoff_round)
    ignore = %w(year player_id franchise_id HO S BS outs HA RA ER BBA KA HB
                WP PB BK created_at updated_at)

    new(where(year: year, franchise_id: franchise_id,
              playoff_round: playoff_round)
      .map(&:attributes)
      .each_with_object({}) do |hash, result|
        hash.each do |key, value|
          (result[key] = result.fetch(key, 0) + value) unless ignore.include?(key)
        end; result
      end)
  end

  def self.player_career_hitting_totals(player_id, playoff_round)
    ignore = %w(year player_id franchise_id HO S BS outs HA RA ER BBA KA HB
                WP PB BK created_at updated_at)

    new(where(player_id: player_id, playoff_round: playoff_round)
    .reject { |stat| stat.PA == 0 }
    .map(&:attributes)
    .each_with_object({}) do |hash, result|
      hash.each do |key, value|
        (result[key] = result.fetch(key, 0) + value) unless ignore.include?(key)
      end; result
    end)
  end

  def self.player_hitting_totals(year, player_id, playoff_round)
    ignore = %w(year player_id franchise_id HO S BS outs HA RA ER BBA KA HB
                WP PB BK created_at updated_at)

    new(where(year: year, player_id: player_id, playoff_round: playoff_round)
    .map(&:attributes)
    .each_with_object({}) do |hash, result|
      hash.each do |key, value|
        (result[key] = result.fetch(key, 0) + value) unless ignore.include?(key)
      end; result
    end)
  end

  def self.all_pitchers(year, franchise_id, playoff_round, innings_threshold)
    all_stats = where(year: year, franchise_id: franchise_id, playoff_round: playoff_round)
      .group_by { |statistic| statistic[:player_id] }

    all_stats.keys.each_with_object({}) { |id, hash| hash[id] = merge(all_stats[id]) }.values
      .select { |statistic| statistic.outs > innings_threshold * 3 && statistic.player.pitcher? }
  end

  def self.team_pitchers(year, franchise_id, playoff_round)
    all_pitchers(year, franchise_id, playoff_round, 0)
  end

  def self.team_pitching_totals(year, franchise_id, playoff_round)
    ignore = %w(year player_id franchise_id AB R H RBI D T HR SB CS K BB SF
                SAC HBP CI created_at updated_at)

    new(where(year: year, franchise_id: franchise_id,
              playoff_round: playoff_round)
      .map(&:attributes)
      .each_with_object({}) do |hash, result|
        hash.each do |key, value|
          (result[key] = result.fetch(key, 0) + value) unless ignore.include?(key)
        end; result
      end)
  end

  def self.player_career_pitching_totals(player_id, playoff_round)
    ignore = %w(year player_id franchise_id AB R H RBI D T HR SB CS K BB SF
                SAC HBP CI created_at updated_at)

    new(where(player_id: player_id, playoff_round: playoff_round)
    .reject { |stat| stat.outs == 0 }
    .map(&:attributes)
    .each_with_object({}) do |hash, result|
      hash.each do |key, value|
        (result[key] = result.fetch(key, 0) + value) unless ignore.include?(key)
      end; result
    end)
  end

  def self.player_pitching_totals(year, player_id, playoff_round)
    ignore = %w(year player_id franchise_id AB R H RBI D T HR SB CS K BB SF
                SAC HBP CI created_at updated_at)

    new(where(year: year, player_id: player_id, playoff_round: playoff_round)
    .map(&:attributes)
    .each_with_object({}) do |hash, result|
      hash.each do |key, value|
        (result[key] = result.fetch(key, 0) + value) unless ignore.include?(key)
      end; result
    end)
  end

  def self.merge(teams)
    if teams.count == 1
      return teams[0]
    else
      combined = teams[0]
      combined.franchise_id = 0

      teams[1..-1].each do |statistic|
        combined.G += statistic.G
        combined.AB += statistic.AB
        combined.R += statistic.R
        combined.H += statistic.H
        combined.RBI += statistic.RBI
        combined.D += statistic.D
        combined.T += statistic.T
        combined.HR += statistic.HR
        combined.SB += statistic.SB
        combined.CS += statistic.CS
        combined.K += statistic.K
        combined.BB += statistic.BB
        combined.SF += statistic.SF
        combined.SAC += statistic.SAC
        combined.HBP += statistic.HBP
        combined.CI += statistic.CI
        combined.W += statistic.W
        combined.L += statistic.L
        combined.HO += statistic.HO
        combined.S += statistic.S
        combined.BS += statistic.BS
        combined.outs += statistic.outs
        combined.HA += statistic.HA
        combined.RA += statistic.RA
        combined.ER += statistic.ER
        combined.BBA += statistic.BBA
        combined.KA += statistic.KA
        combined.HB += statistic.HB
        combined.WP += statistic.WP
        combined.PB += statistic.PB
        combined.BK += statistic.BK
        combined.E += statistic.E
      end

      return combined
    end 
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
    (self.HA + self.BBA) / (outs / 3.0)
  end

  def ERA
    (self.ER / (outs / 3.0)) * 9
  end

  def WinPct
    self.W / (self.W + self.L).to_f * 100.0
  end

  def SavePct
    self.S / (self.S + self.BS).to_f * 100.0
  end

  def IP
    "#{self.outs / 3}.#{self.outs % 3}".to_f
  end
end
