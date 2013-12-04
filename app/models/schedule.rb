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
    "#{self.away.full_name} at #{self.home.full_name}"
  end

  def short_description
    "#{self.away.nickname} at #{self.home.nickname}"
  end

  def abbreviated_description
    "#{self.away.abbreviation.upcase} at #{self.home.abbreviation.upcase}"
  end

end
