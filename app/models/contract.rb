# Describes a player's contract for a given franchise and year
class Contract < ActiveRecord::Base
  self.primary_keys = :year, :franchise_id, :player_id

  attr_accessible :player_id, :franchise_id, :year, :salary, :released

  belongs_to :team, foreign_key: [:year, :franchise_id]
  belongs_to :player,  foreign_key: [:year, :player_id]

  def self.under_contract(year, franchise_id, include_released = true)
    where(year: year, franchise_id: franchise_id)
      .select { |contract| include_released || contract.released == false}
      .map { |contract| contract.player }
      .sort_by { |player| [player.last_name.upcase, player.first_name.upcase] }
  end

  def self.under_contract_per_position(year, franchise_id, position, include_released = true)
    under_contract(year, franchise_id, include_released)
      .select { |player| player.position.upcase == position.upcase }
  end

  def self.total_salary(year, franchise_id)
    where(year: year, franchise_id: franchise_id)
      .map { |contract| contract.salary.round(1) }.sum
  end

  def self.salary_cap(year, franchise_id)
    begin 
      Team.find(year, franchise_id).salary_cap 
    rescue 
      BigDecimal.new("63.0")
    end
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

  def self.signing_period 
    Time.zone = 'Pacific Time (US & Canada)'
    now = Time.current.to_date

    if ((Date.today.beginning_of_year)..(Draft.draft_day - 2.weeks)).cover?(now)
      0
    elsif (((Draft.draft_day - 2.weeks).next_day)..(Date.new(Date.today.year, 3, 31))).cover?(now)
      1
    elsif ((Date.new(Date.today.year, 4, 1))..(Date.new(Date.today.year, 6, 30))).cover?(now)
      2
    elsif ((Date.new(Date.today.year, 7, 1))..(Date.new(Date.today.year, 9, 15))).cover?(now)
      3
    else
      0
    end
  end

  def self.extension_cost(current_salary, period = nil)
    period ||= signing_period

    if current_salary >= 5
      period * 1.2
    elsif current_salary >= 4
      period * 1.0
    elsif current_salary >= 3
      period * 0.8
    elsif current_salary >= 2
      period * 0.6
    elsif current_salary >= 1
      period * 0.5
    else
      period * 0.4
    end       
  end

  def self.grandfathered?(player_id)
    Transaction.where(player_id: player_id, transaction_type: ['SIGN', 'DRAFT']).where('year >= ?', 2017).empty?
  end
end
