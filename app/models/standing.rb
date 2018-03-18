# Describes the standings for a given year
class Standing < ActiveRecord::Base
  self.primary_keys = :year, :franchise_id

  attr_accessible :division, :franchise_id, :league, :losses, :playoff_berth,
                  :playoff_round, :streak, :wins, :year

  belongs_to :team, foreign_key: [:year, :franchise_id]

  def self.update(boxscore)
    unless boxscore.W == 0 && boxscore.L == 0

      divisions = %w(Reese Robinson Grove Cochrane)
      leagues = %w(American National)

      standing = find_or_create_by_year_and_franchise_id(
        boxscore.year, boxscore.franchise_id)

      standing.league = leagues[(boxscore.franchise_id - 1) / 12]
      standing.division = divisions[(boxscore.franchise_id - 1) / 6]
      standing.wins += boxscore.W
      standing.losses += boxscore.L

      if standing.streak >= 0 && !boxscore.W.zero?
        standing.streak += boxscore.W
      elsif standing.streak >= 0 && !boxscore.L.zero?
        standing.streak = -1
      elsif standing.streak <= 0 && !boxscore.L.zero?
        standing.streak -= boxscore.L
      else
        standing.streak = 1
      end

      standing.save
    end
  end

  def self.leagues(year)
    where(year: year).uniq.pluck(:league)
  end

  def self.divisions(year)
    where(year: year).uniq.pluck(:division)
  end

  def self.divisions_by_league(year, league)
    records_by_league(year, league).uniq.pluck(:division)
  end

  def self.records_by_league(year, league)
    where(year: year, league: league)
  end

  def self.records_by_divisions(year, division)
    where(year: year, division: division)
  end

  def win_percentage
    wins / (wins + losses).to_f
  end

  def games_back_division
    records = Standing.records_by_divisions(year, division)

    wins_back = records.empty? ? 0 : records.max_by { |standing| standing.wins }.wins - wins
    losses_back = records.empty? ? 0 : losses - records.max_by { |standing| standing.wins }.losses

    games_back = (wins_back + losses_back).to_f / 2.0

    if games_back.to_i == games_back.to_f
      games_back.to_i
    else
      games_back.to_f
    end
  end

  def games_back_wildcard
    divisions = []

    records = records_by_league(year, league).map do |record|
      if record.games_back_division == 0 && !divisions.include?(record.division)
        divisions.push(record.division)
        nil
      else
        record
      end
    end

    wins_back = records.empty? ? 0 : records.compact.max_by { |standing| standing.wins }.wins - wins
    losses_back = records.empty? ? 0 : losses - records.compact.max_by { |standing| standing.wins }.games_back_division

    games_back = (wins_back + losses_back).to_f / 2.0

    if games_back.to_i == games_back.to_f
      games_back.to_i
    else
      games_back.to_f
    end
  end

  def record
    "#{wins} - #{losses}"
  end

  def postseason
    postseason = []

    unless playoff_berth.nil? || playoff_berth == ''
      postseason.push('James Huang Memorial Champion') if playoff_round >= 4
      postseason.push("#{league} League Champion") if playoff_round >= 3
      postseason.push("#{division} Division Champion") if playoff_round >= 1 && playoff_berth == 'D'
      postseason.push('Wildcard Champion') if playoff_round >= 1 && playoff_berth == 'W'
    end

    postseason
  end

  def ranking_value
    playoff_round = 0 if playoff_round.nil?

    (wins / 12.5) + (playoff_round * 8.0)
  end
end
