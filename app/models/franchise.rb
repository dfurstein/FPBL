class Franchise < ActiveRecord::Base
  self.primary_keys = :year, :franchise_id

  attr_accessible :franchise_id, :owner_id, :team_id, :year, :dmb_id

  belongs_to :team
  belongs_to :owner
  has_one :performance, :foreign_key => [:year, :franchise_id]
  has_many :contracts, :foreign_key => [:year, :franchise_id]

  def self.current_team(franchise_id)
    self.find(self.last.year, franchise_id).team
  end

  def self.current_teams
    self.where("year = #{self.last.year}").collect {
      |franchise| franchise.team
    }.sort_by {
      |team| team.full_name
    }
  end

  def self.current_owner(franchise_id)
    self.find(self.last.year, franchise_id).owner
  end
end
