class Contract < ActiveRecord::Base
  attr_accessible :franchise_id, :player_id, :release, :salary, :year

  belongs_to :season, :foreign_key => [:year, :franchise_id]
  belongs_to :player
end
