class Schedule < ActiveRecord::Base
  attr_accessible :away_score, :away_team, :date, :extra_innings, :home_score, :home_team

  def home
    Season.where("year = #{self.date.year}").collect { |season| 
      season.team
    }.find { |team| 
      team.abbreviation.upcase == self.home_team.upcase 
    }
  end

  def away
    Season.where("year = #{self.date.year}").collect { |season| 
      season.team
    }.find { |team| 
      team.abbreviation.upcase == self.away_team.upcase 
    }
  end
end
