# Model for a player
class Player < ActiveRecord::Base
  self.primary_keys = :year, :player_id

  attr_accessible :player_id, :year, :dmb_name, :first_name, :last_name,
                  :position, :active

  has_many :contracts, primary_key: :player_id
  has_many :teams,  foreign_key: [:year, :franchise_id], through: :contracts

  def self.player_id_by_dmb_name(year, dmb_name)
    where(year: year, dmb_name: dmb_name).pluck(:player_id).first
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
    existing_players = where('year < ?', year).pluck(:player_id).uniq
    signed_players = Contract.where(year: year, released: FALSE)
      .pluck(:player_id).uniq

    where('year = ? and player_id not in (?)', year,
          existing_players | signed_players)
      .sort_by { |player| [player.last_name.upcase, player.first_name.upcase] }
  end

  def self.free_agents(year)
    signed_players = Contract.where(year: year, released: FALSE)
      .pluck(:player_id).uniq

    where('year = ? and active = ? and player_id not in (?)',
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

  def free_agent_salary
    free_agent_draft = Draft.draft_day + 3.weeks
    start_of_season = DateTime.new(year, 4, 2)
    today = DateTime.now

    if today <= free_agent_draft
      BigDecimal.new('4.0')
    elsif today <= free_agent_draft + 1.week
      BigDecimal.new('3.0')
    elsif today <= free_agent_draft + 2.week
      BigDecimal.new('2.0')
    elsif today <= free_agent_draft + 3.week
      BigDecimal.new('1.0')
    elsif today <= free_agent_draft + 4.week
      BigDecimal.new('0.5')
    elsif today <= free_agent_draft + 5.week
      BigDecimal.new('0.1')
    elsif last_contract_before_release.nil?
      BigDecimal.new('0.1')
    elsif last_contract_before_release.updated_at <= free_agent_draft
      BigDecimal.new('0.1')
    elsif last_contract_before_release.updated_at <= start_of_season  &&
      today <= start_of_season
      last_contract_before_release.salary * 2
    else
      ((last_contract_before_release.salary * 2) /
        (2**(
          ((DateTime.now - [last_contract_before_release.updated_at, start_of_season].max.to_datetime).to_f / 7.0).to_i
          )
        )
      ).ceil(1)
    end
  end

  def last_contract_before_release
    contracts.where(year: year, released: TRUE).order('updated_at desc').first
  end
end
