class Team < ActiveRecord::Base
  attr_accessible :abbreviation, :location, :nickname

  def full_name
    self.location + " " + self.nickname
  end

  def get_current_franchise_id
    Season.find_by_year_and_team_id(Season.last.year, self.id).franchise_id
  end
end
