# Model for a schedule
class Schedule < ActiveRecord::Base
  attr_accessible :date, :home_team, :home_score, :away_team, :away_score,
                  :extra_innings

  @@teams = Hash[Team.all.map { |team| [[team.year, team.abbreviation.upcase], team] }]

  def home
    @@teams[[date.year, home_team.upcase]]
  end

  def away
    @@teams[[date.year, away_team.upcase]]
  end

  def self.games(date)
    where(date: date..date.end_of_month)
  end

  def long_description
    if away_score == 0 && home_score == 0
      "#{away.name} at #{home.name}"
    else
      "#{away.name} #{away_score}, #{home.name} #{home_score}"
    end
  end

  def short_description
    if away_score == 0 && home_score == 0
      "#{away.nickname} at #{home.nickname}"
    else
      "#{away.nickname} #{away_score}, #{home.nickname} #{home_score}"
    end
  end

  def abbreviated_description
    if away_score == 0 && home_score == 0
      "#{away.abbreviation.upcase} at #{home.abbreviation.upcase}"
    else
      "#{away.abbreviation.upcase} #{away_score}, #{home.abbreviation.upcase} #{home_score}"
    end
  end

  def dmb_file
    "#{date.year}#{'%02d' % date.month}#{'%02d' % date.day}#{'%04d' % Team.find(date.year, home.franchise_id).dmb_id}0"
  end
end
