# Model for a player
class Player < ActiveRecord::Base
  self.primary_keys = :year, :player_id

  attr_accessible :player_id, :year, :dmb_name, :first_name, :last_name,
                  :position, :active

  has_many :contracts, primary_key: :player_id
  has_many :teams,  foreign_key: [:year, :franchise_id], through: :contracts

  def self.player_id_by_dmb_name(year, dmb_name)
    Player.where(year: year, dmb_name: dmb_name).pluck(:player_id).first
  end

  # ['SP', 'MR', 'CL', 'C', '1B', '2B', '3B', 'SS', 'LF', 'CF', 'RF', 'DH']
  def self.position_name(position)
    case position.upcase
    when 'SP'
      'Starting Pitcher'
    when 'MR'
      'Relief Pitcher'
    when 'CL'
      'Closer'
    when 'C'
      'Catcher'
    when '1B'
      'First Baseman'
    when '2B'
      'Second Baseman'
    when 'SS'
      'Shortstop'
    when '3B'
      'Third Baseman'
    when 'LF'
      'Left Fielder'
    when 'CF'
      'Center Fielder'
    when 'RF'
      'Right Fielder'
    when 'DH'
      'Designated Hitter'
    else
      'Unknown Position'
    end
  end

  def self.rookies(year)
    existing_players = Player.where('year < ?', year).pluck(:player_id).uniq
    signed_players = Contract.where(year: 2015, released: FALSE)
      .pluck(:player_id).uniq

    Player.where('year = ? and player_id not in (?)', year,
                 existing_players | signed_players)
      .sort_by { |player| [player.last_name.upcase, player.first_name.upcase] }
  end

  def self.free_agents(year)
    signed_players = Contract.where(year: 2015, released: FALSE)
      .pluck(:player_id).uniq

    Player.where('year = ? and active = ? and player_id not in (?)',
                 year, TRUE, signed_players)
      .sort_by { |player| [player.last_name.upcase, player.first_name.upcase] }
  end

  def name
    first_name + ' ' + last_name
  end

  def pitcher?
    pitchers = %w(SP MR CL)

    pitchers.include?(position.upcase)
  end

  def hitter?
    !pitcher?
  end

  def current_contract(year, franchise_id)
    contracts.where(franchise_id: franchise_id).where('year >= ?', year)
  end
end
