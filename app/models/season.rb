require 'composite_primary_keys'

class Season < ActiveRecord::Base
  self.primary_keys = :year, :franchise_id

  attr_accessible :franchise_id, :owner_id, :team_id, :year

  belongs_to :team
  belongs_to :owner

  def self.get_current_team(franchise_id)
    self.find(self.last.year, franchise_id).team
  end

  def self.get_current_teams
    self.where("year = #{self.last.year}").collect { 
      |franchise| franchise.team
    }.sort_by { 
      |team| team.full_name
    }
  end
end
