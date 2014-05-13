require 'spec_helper'

#attr_accessible :dmb_id, :first_name, :last_name, :position

describe Player do
  it "display first and last names together" do
    player = FactoryGirl.build(:player, :first_name => "John", :last_name => "Smith")

    expect(player.full_name).to eq("John Smith")
  end

  it "retrieve contracts for a given franchise in a specific year" do
    contract01 = FactoryGirl.create(:contract, :franchise_id => 1, :player_id => 1, :year => 2013, :release => false)
    contract02 = FactoryGirl.create(:contract, :franchise_id => 1, :player_id => 1, :year => 2014 , :release => true)
    contract03 = FactoryGirl.create(:contract, :franchise_id => 2, :player_id => 1, :year => 2014, :release => false)
    contract04 = FactoryGirl.create(:contract, :franchise_id => 1, :player_id => 2, :year => 2014, :release => false)

    player01 = FactoryGirl.create(:player)
    player02 = FactoryGirl.create(:player)

    expect(player01.current_contract(2014, 1)).to eq([contract02])
    expect(player02.current_contract(2014, 1)).to eq([contract04])

    expect(player01.current_contract(2014, 2)).to eq([contract03])
    expect(player02.current_contract(2014, 2)).to eq([])
  end
end
