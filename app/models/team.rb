# Model for Team
class Team < ActiveRecord::Base
  self.primary_keys = :year, :franchise_id

  attr_accessible :franchise_id, :year, :city, :nickname, :abbreviation,
                  :stadium, :owner_id, :salary_cap, :dmb_id

  has_many :contracts, foreign_key: [:year, :franchise_id]
  has_many :players,  foreign_key: [:year, :player_id], through: :contracts

  def full_name
    city + ' ' + nickname
  end
end
