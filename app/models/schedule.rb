class Schedule < ActiveRecord::Base
  attr_accessible :away_score, :away_team, :date, :extra_innings, :home_score, :home_team

  def home
    season = Season.where("year = #{self.date.year}").includes(:team).find{ 
      |season| season.team.abbreviation.upcase == self.home_team.upcase }

    season.team
  end

  def away
    season = Season.where("year = #{self.date.year}").includes(:team).find{ 
      |season| season.team.abbreviation.upcase == self.away_team.upcase }

    season.team
  end

  #Convert milliseconds to datetime
  def self.milliseconds_to_date(time)
    Time.at(time / 1000.0).to_datetime
  end

  #Convert milliseconds to datetime
  def self.date_to_milliseconds(date)
    (date.to_time.to_f * 1000).to_i
  end

end
