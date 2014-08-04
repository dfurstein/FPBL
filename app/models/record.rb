# Describes the standings for a given year
class Record < ActiveRecord::Base
  self.primary_keys = :year, :franchise_id

  attr_accessible :division, :franchise_id, :league, :losses, :playoff_berth,
                  :playoff_depth, :streak, :wins, :year

  belongs_to :season, foreign_key: [:year, :franchise_id]

  def self.leagues(year)
    Record.where("year = #{year}").uniq.pluck(:league)
  end

  def self.divisions_per_league(year, league)
    Record.where("year = #{year} and league = '#{league}'").uniq
      .pluck(:division)
  end

  def self.performances_per_division(year, league, division)
    Record.where("year = #{year} and league = '#{league}'
      and division = '#{division}'")
  end

  def win_percentage
    (wins / (wins + losses).to_f).round(3)
  end

  def game_streak
    if streak > 0
      "W#{streak}"
    else
      "L#{streak.abs}"
    end
  end

  def games_back_division
    games_back = Record.where(
        "year = #{year} and league = '#{league}' and division = '#{division}'"
      ).max_by { |record| record.wins }.wins - wins

    if games_back == 0
      '-'
    else
      games_back
    end
  end
end
