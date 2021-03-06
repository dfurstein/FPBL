# Model for Team
class Team < ActiveRecord::Base
  self.primary_keys = :year, :franchise_id

  attr_accessible :franchise_id, :year, :city, :nickname, :abbreviation,
                  :stadium, :owner_id, :salary_cap, :penalty, :dmb_id

  has_many :contracts, foreign_key: [:year, :franchise_id]
  has_many :players,  foreign_key: [:year, :player_id], through: :contracts
  has_one :standing, foreign_key: [:year, :franchise_id]
  belongs_to :owner

  def self.franchise_id_by_abbreviation(year, abbreviation)
    where(year: year, abbreviation: abbreviation.upcase)
      .pluck(:franchise_id).first
  end

  def self.update_penalty(year, franchise_id, penalty)
    team = find(year, franchise_id)
    team.penalty = penalty

    team.save
  end

  def self.current_teams
    where(year: last.year).map { |team| team }.sort_by { |team| team.name }
  end

  def name
    city + ' ' + nickname
  end

  def rankings
    Ranking.where(franchise_id: franchise_id)
  end
end
