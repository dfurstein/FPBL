# Describes a player's contract for a given franchise and year
class Contract < ActiveRecord::Base
  self.primary_keys = :year, :franchise_id, :player_id

  attr_accessible :player_id, :franchise_id, :year, :salary, :released

  belongs_to :team, foreign_key: [:year, :franchise_id]
  belongs_to :player,  foreign_key: [:year, :player_id]

  def self.under_contract(year, franchise_id)
    where(year: year, franchise_id: franchise_id)
      .map { |contract| contract.player }
      .sort_by { |player| [player.last_name.upcase, player.first_name.upcase] }
  end

  def self.under_contract_per_position(year, franchise_id, position)
    under_contract(year, franchise_id)
      .select { |player| player.position.upcase == position.upcase }
  end

  def self.total_salary(year, franchise_id)
    where(year: year, franchise_id: franchise_id)
      .map { |contract| contract.salary.round(1) }.sum
  end

  def self.salary_cap(year, franchise_id)
    Team.find(year, franchise_id).salary_cap
  end

  def self.available_salary_cap(year, franchise_id)
    salary_cap(year, franchise_id) - total_salary(year, franchise_id)
  end

  def self.total_active_players(year, franchise_id)
    players = where(year: year, franchise_id: franchise_id,
                    released: false)
      .map { |contract| contract.player }

    if year == Team.last.year
      players.select { |player| player.active }.count
    else
      players.count
    end
  end

  def self.total_inactive_players(year, franchise_id)
    where(year: year, franchise_id: franchise_id).count -
      total_active_players(year, franchise_id)
  end

  def self.remove_inactive_released_players(year, franchise_id)
    where(year: year, franchise_id: franchise_id, released: true)
      .map { |contract| contract unless contract.player.active }.compact
      .each { |contract| contract.destroy }
  end
end
