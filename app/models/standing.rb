# Describes the standings for a given year
class Standing < ActiveRecord::Base
  self.primary_keys = :year, :franchise_id

  attr_accessible :division, :franchise_id, :league, :losses, :playoff_berth,
                  :playoff_depth, :streak, :wins, :year

  belongs_to :team, foreign_key: [:year, :franchise_id]

  def self.leagues(year)
    Standing.where("year = #{year}").uniq.pluck(:league)
  end

  def self.divisions_by_league(year, league)
    Standing.where("year = #{year} and league = '#{league}'").uniq.pluck(:division)
  end

  def self.records_by_divisions(year, league, division)
    Standing.where("year = #{year} and league = '#{league}'
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
    games_back = Standing.where(
        "year = #{year} and league = '#{league}' and division = '#{division}'"
      ).max_by { |standing| standing.wins }.wins - wins

    if games_back == 0
      '-'
    else
      games_back
    end
  end
end
