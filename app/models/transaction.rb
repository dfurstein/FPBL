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

    group_id = extend_group_id(franchise_id, 'EXTEND')
    transaction = find_or_create_by_player_id_and_transaction_group_id(player_id, group_id) do |transaction|
      transaction.transaction_type = 'EXTEND'
      transaction.year = Team.last.year
      transaction.franchise_id_to = franchise_id
    end

    transaction.extension_year = year
    transaction.processed_at = DateTime.now
    transaction.save
  end

  def self.release_player_pending(player_id, franchise_id)
    group_id = release_group_id(franchise_id)
    transaction = find_or_create_by_player_id_and_transaction_group_id(player_id, group_id) do |transaction|
      transaction.transaction_type = 'RELEASE'
      transaction.year = Team.last.year
      transaction.franchise_id_from = franchise_id
    end

    transaction.save
  end

  def self.undo_release_player_pending(player_id, franchise_id)
    find_by_player_id_and_franchise_id_from_and_transaction_type_and_processed_at(player_id,
      franchise_id, 'RELEASE', nil).delete
  end

  def self.release_players
    where(transaction_type: 'RELEASE', processed_at: nil).each do |transaction|
      Contract.where(franchise_id: transaction.franchise_id_from, player_id: transaction.player_id, released: false)
        .where('year >= ?', transaction.year).each do |contract|
          active = contract.player.active if contract.year == transaction.year
          unless active
            contract.destroy
          else
            contract.released = true
            contract.save
          end
      end

      transaction.processed_at = DateTime.now
      transaction.save
    end
  end

  def self.future_releases_count(franchise_id)
    count = [0, 0, 0, 0, 0]

    where(franchise_id_from: franchise_id, transaction_type: 'RELEASE', processed_at: nil).each do |transaction| 
      transaction.player.contracts
        .where(franchise_id: transaction.franchise_id_from, released: false)
        .where('year >= ?', Team.last.year)
        .each_with_index do |contract, index| 
          count[index] += 1 
      end 
    end

    count
  end

  def self.future_releases_salaries(franchise_id)
    salaries = [0, 0, 0, 0, 0]

    where(franchise_id_from: franchise_id, transaction_type: 'RELEASE', processed_at: nil).each do |transaction| 
      transaction.player.contracts
        .where(franchise_id: transaction.franchise_id_from, released: false)
        .where('year >= ?', Team.last.year)
        .each_with_index do |contract, index| 
          salaries[index] += contract.salary.div(2, 3).round(1) 
      end 
    end

    salaries
  end

  def self.extend_group_id(franchise_id)
    where(franchise_id_to: franchise_id, transaction_type: 'EXTEND')
      .where('created_at >= ?', DateTime.now - 5.minutes)
      .pluck(:transaction_group_id)
      .first || maximum(:transaction_group_id) + 1
  end

  def self.release_group_id(franchise_id)
    where(franchise_id_from: franchise_id, transaction_type: 'RELEASE', processed_at: nil)
      .where('created_at >= ?', DateTime.now - 1.week)
      .pluck(:transaction_group_id)
      .first || maximum(:transaction_group_id) + 1
  end

  def other_involved_transactions
    Transaction.where(transaction_group_id: transaction_group_id).select do |transaction| 
      transaction[:player_id] != player_id
    end
  end

  def other_players_coming
    other_involved_transactions
      .select { |transaction| transaction[:franchise_id_from] == franchise_id_from && transaction[:player_id] != nil }
      .collect { |transaction| Player.find(transaction.year, transaction.player_id).name }
  end

  def other_picks_coming
    other_involved_transactions
      .select { |transaction| transaction[:franchise_id_from] == franchise_id_from }
      .collect do |transaction| 
        Draft.draft_selection_by_original_owner(transaction.draft_year, transaction.draft_round, transaction.draft_franchise_id_original)
      end
  end

  def other_players_going
    other_involved_transactions
      .select { |transaction| transaction[:franchise_id_from] == franchise_id_to && transaction[:player_id] != nil }
      .collect { |transaction| Player.find(transaction.year, transaction.player_id).name }
  end

  def other_picks_going
    other_involved_transactions
      .select { |transaction| transaction[:franchise_id_from] == franchise_id_to }
      .collect do |transaction| 
        Draft.draft_selection_by_original_owner(transaction.draft_year, transaction.draft_round, transaction.draft_franchise_id_original)
      end
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
