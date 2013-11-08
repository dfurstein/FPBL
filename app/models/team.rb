class Team < ActiveRecord::Base
  attr_accessible :abbreviation, :location, :nickname

  has_many :seasons

  def full_name
    self.location + " " + self.nickname
  end

  def franchise_id
    self.seasons.last.franchise_id
  end

  # def get_current_franchise_id
  #   season = Team.find(self.id).seasons.find_by_year(Season.last.year)
    
  #   unless season.nil?
  #     season.franchise_id
  #   end
  # end
end
