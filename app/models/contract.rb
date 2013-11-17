class Contract < ActiveRecord::Base
  attr_accessible :franchise_id, :player_id, :release, :salary, :year

  belongs_to :season, :foreign_key => [:year, :franchise_id]
  belongs_to :player

  def self.under_contract(year, franchise_id)
    Contract.where("year = #{year} and franchise_id = #{franchise_id}").collect { |contract| 
      contract.player 
    }.sort_by { |player| 
      [player.last_name, player.first_name]
    }
  end

  def self.under_contract_per_position(year, franchise_id, position)
    Contract.under_contract(year, franchise_id).find_all { |player| player.position.upcase == position.upcase }
  end
end
