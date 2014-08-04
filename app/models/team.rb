# Model for Team
class Team < ActiveRecord::Base
  attr_accessible :franchise_id, :year, :city, :nickname, :abbreviation,
                  :stadium, :owner_id, :salary_cap, :dmb_id

  def full_name
    city + ' ' + nickname
  end
end
