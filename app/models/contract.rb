# Describes a player's contract for a given franchise and year
class Contract < ActiveRecord::Base
  attr_accessible :player_id, :franchise_id, :year, :salary, :released

  belongs_to :team, foreign_key: [:year, :franchise_id]
  belongs_to :player

  def self.under_contract(year, franchise_id)
    Contract.where("year = #{year} and franchise_id = #{franchise_id}")
      .map { |contract| contract.player }
      .sort_by { |player| [player.last_name, player.first_name] }
  end

  def self.under_contract_per_position(year, franchise_id, position)
    Contract.under_contract(year, franchise_id)
      .select { |player| player.position.upcase == position.upcase }
  end
end
