class Team < ActiveRecord::Base
  attr_accessible :abbreviation, :location, :nickname

  has_many :seasons

  def full_name
    self.location + " " + self.nickname
  end

  def franchise_id
    self.seasons.last.franchise_id
  end
end
