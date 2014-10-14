# Describes a selection in the rookie draft
class Draft < ActiveRecord::Base
  self.primary_keys = :year, :round, :selection

  attr_accessible :year, :round, :selection, :franchise_id_current,
                  :franchise_id_original, :player_id

  belongs_to :player,  foreign_key: [:year, :player_id]
  belongs_to :team,  foreign_key: [:year, :franchise_id_current]

  def self.rounds(year)
    where(year: year).uniq.pluck(:round)
  end

  def self.selections_by_round(year, round)
    where(year: year, round: round).uniq.pluck(:selection)
  end

  def self.draft_selection(year, round, selection)
    where(year: year, round: round, selection: selection).first
  end
end
