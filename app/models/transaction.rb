# Describes a transaction
class Transaction < ActiveRecord::Base
  attr_accessible :transaction_group_id, :transaction_type, :year,
                  :franchise_id_to, :franchise_id_from, :player_id,
                  :extension_year, :draft_year, :draft_round,
                  :draft_franchise_id_original, :processed_at

  belongs_to :player,  foreign_key: [:year, :player_id]

  def self.all_ids(franchise_id, transaction_type, from_date, to_date)
    Transaction.where(processed_at: from_date..to_date)
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
