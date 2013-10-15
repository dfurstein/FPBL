class Season < ActiveRecord::Base
  attr_accessible :franchise_id, :owner_id, :team_id, :year

  belongs_to :team
  belongs_to :owner
end
