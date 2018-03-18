# Describes a transaction
class Transaction < ActiveRecord::Base
  attr_accessible :transaction_group_id, :transaction_type, :year,
                  :franchise_id_to, :franchise_id_from, :player_id,
                  :extension_year, :draft_year, :draft_round,
                  :draft_franchise_id_original, :processed_at

  belongs_to :player,  foreign_key: [:year, :player_id]

  def self.all_ids(franchise_id, transaction_type, from_date, to_date)
    where(processed_at: from_date..to_date)
    .where(from_franchise_id(franchise_id))
    .where(from_transaction_type(transaction_type))
    .pluck(:transaction_group_id).uniq
  end

  def self.from_franchise_id(franchise_id)
    "franchise_id_to = #{franchise_id} OR franchise_id_from = #{franchise_id}" unless franchise_id.nil?
  end

  def self.from_transaction_type(transaction_type)
    "transaction_type = '#{transaction_type}'" unless transaction_type.nil?
  end

  def self.extend_player(player_id, franchise_id, year, salary)
    contract = Contract.find_or_create_by_player_id_and_franchise_id_and_year(player_id: player_id, 
      franchise_id: franchise_id, year: year) do |contract|
      contract.salary = salary
    end

    contract.salary = salary
    contract.released = FALSE
    contract.save

    group_id = extend_group_id(franchise_id);
    transaction = find_or_create_by_player_id_and_transaction_group_id(player_id: player_id, transaction_group_id: group_id) do |transaction|
      transaction.transaction_type = 'EXTEND'
      transaction.year = Team.last.year
      transaction.franchise_id_to = franchise_id
    end

    transaction.extension_year = year
    transaction.processed_at = DateTime.now
    transaction.save
  end

  def self.extend_group_id(franchise_id)
    where(franchise_id_to: franchise_id, transaction_type: "EXTEND")
      .where('processed_at >= ?', DateTime.now - 5.minutes)
      .pluck(:transaction_group_id)
      .first || maximum(:transaction_group_id) + 1
  end

  def to_team
    Team.find(year, franchise_id_to)
  end

  def from_team
    Team.find(year, franchise_id_from)
  end

  def draft
    Draft.where(year: draft_year, round: draft_round,
                franchise_id_original: draft_franchise_id_original).first
  rescue
    nil
  end

  def draft_team
    Team.find(draft_year, draft_franchise_id_original)
  rescue
    Team.find(year, draft_franchise_id_original)
  end
end
