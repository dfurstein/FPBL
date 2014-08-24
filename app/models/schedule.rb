# Describes a schedule from DMB
class Schedule < ActiveRecord::Base
  attr_accessible :date, :home_team_abbreviation, :home_score,
                  :away_team_abbreviation, :away_score,
                  :extra_innings

  @@teams = Hash[Team.all.map { |team| [[team.year, team.abbreviation.upcase], team] }]

  def home_team
    @@teams[[date.year, home_team_abbreviation.upcase]]
  end

  def away_team
    @@teams[[date.year, away_team_abbreviation.upcase]]
  end

  def self.games(date)
    where(date: date..date.end_of_month)
  end

  def long_description
    if away_score == 0 && home_score == 0
      "#{away_team.name} at #{home_team.name}"
    else
      "#{away_team.name} #{away_score}, #{home_team.name} #{home_score}"
    end
  end

  def short_description
    if away_score == 0 && home_score == 0
      "#{away_team.nickname} at #{home_team.nickname}"
    else
      "#{away_team.nickname} #{away_score}, #{home_team.nickname} #{home_score}"
    end
  end

  def abbreviated_description
    if away_score == 0 && home_score == 0
      "#{away_team.abbreviation.upcase} at #{home_team.abbreviation.upcase}"
    else
      "#{away_team.abbreviation.upcase} #{away_score}, #{home_team.abbreviation.upcase} #{home_score}"
    end
  end

  def dmb_file
    "#{date.year}#{'%02d' % date.month}#{'%02d' % date.day}#{'%04d' % Team.find(date.year, home_team.franchise_id).dmb_id}0"
  end
end
