class Schedule < ActiveRecord::Base
  attr_accessible :away_score, :away_team, :date, :extra_innings, :home_score, :home_team

  @@teams = Hash[Season.includes(:team).collect { |season| [[season.year, season.team.abbreviation.upcase], season.team] }]

  def home
    @@teams[[self.date.year, self.home_team.upcase]]
  end

  def away
    @@teams[[self.date.year, self.away_team.upcase]]
  end

  def self.games(date)
     self.where(date: date..date.end_of_month)
  end

  def long_description
    if self.away_score == 0 and self.home_score == 0
      "#{self.away.full_name} at #{self.home.full_name}"
    else
      "#{self.away.full_name} #{self.away_score}, #{self.home.full_name} #{self.home_score}"
    end
  end

  def short_description   
    if self.away_score == 0 and self.home_score == 0
      "#{self.away.nickname} at #{self.home.nickname}"
    else
      "#{self.away.nickname} #{self.away_score}, #{self.home.nickname} #{self.home_score}"
    end
  end

  def abbreviated_description
    if self.away_score == 0 and self.home_score == 0
      "#{self.away.abbreviation.upcase} at #{self.home.abbreviation.upcase}"
    else
      "#{self.away.abbreviation.upcase} #{self.away_score}, #{self.home.abbreviation.upcase} #{self.home_score}"
    end
  end

end
