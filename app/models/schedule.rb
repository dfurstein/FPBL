class Schedule < ActiveRecord::Base
  attr_accessible :date, :extra_innings, :home_score, :home_team, :road_score, :road_team
end
