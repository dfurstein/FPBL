# Describes the standings for a given year
class Standing < ActiveRecord::Base
  self.primary_keys = :year, :franchise_id

  attr_accessible :division, :franchise_id, :league, :losses, :playoff_berth,
                  :playoff_round, :streak, :wins, :year

  belongs_to :team, foreign_key: [:year, :franchise_id]

  def self.update(boxscore)
    unless boxscore.W == 0 && boxscore.L == 0

      divisions = %w(Tinker Evers Chance Reulbach Brown Pfeister)
      leagues = %w(American National)

      standing = find_or_create_by_year_and_franchise_id(
        boxscore.year, boxscore.franchise_id)

      standing.league = leagues[(boxscore.franchise_id - 1) / 12]
      standing.division = divisions[(boxscore.franchise_id - 1) / 4]
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
    format('%.03f', (wins / (wins + losses).to_f).round(3))
  end

  def game_streak
    if streak > 0
      "W#{streak}"
    else
      "L#{streak.abs}"
    end
  end

  def games_back_division
    records = Standing.records_by_divisions(year, division)

    if records.empty?
      0
    else
      records.max_by { |standing| standing.wins }.wins - wins
    end
  end

  def games_back_division_formatted
    games_back_division == 0 ? '-' : games_back_division
  end

  def games_back_wildcard
    divisions = []

    records = Standing.records_by_league(year, league).map do |record|
      if record.games_back_division == 0 && !divisions.include?(record.division)
        divisions.push(record.division)
        nil
      else
        record
      end
    end

    if records.empty?
      0
    else
      records.compact.max_by { |standing| standing.wins }.wins - wins
    end
  end

  def record
    "#{wins} - #{losses}"
  end
end
