# Describes who currently own what pick in future drafts
class DraftRight < ActiveRecord::Base
  self.primary_keys = :year, :round, :franchise_id_original

  attr_accessible :year, :round, :franchise_id_current, :franchise_id_original

  belongs_to :team,  foreign_key: [:year, :franchise_id_current]

  def current_team(year)
    Team.find(year, franchise_id_current).name
  end

  def original_team(year)
    Team.find(year, franchise_id_original).name
  end
end
