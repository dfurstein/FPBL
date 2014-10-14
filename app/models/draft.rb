# Describes a selection in the rookie draft
class Draft < ActiveRecord::Base
  self.primary_keys = :year, :round, :selection

  attr_accessible :year, :round, :selection, :franchise_id_current,
                  :franchise_id_original, :player_id
end
