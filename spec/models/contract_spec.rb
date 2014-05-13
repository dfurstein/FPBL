require 'spec_helper'

#attr_accessible :franchise_id, :player_id, :release, :salary, :year

describe Contract do
  it "retrieve all players under contract" do
    contract01 = FactoryGirl.create(:contract, :franchise_id => 1, :year => 2013)
    contract02 = FactoryGirl.create(:contract, :franchise_id => 1, :year => 2014)
    contract03 = FactoryGirl.create(:contract, :franchise_id => 1, :year => 2014)
    contract04 = FactoryGirl.create(:contract, :franchise_id => 2, :year => 2014)

    expect(Contract.under_contract(2014, 1)).to eq([contract02.player, contract03.player])
  end

  it "retrieve all players under contract as a specific position" do
    player01 = FactoryGirl.create(:player, :position => "1B")
    player02 = FactoryGirl.create(:player, :position => "ss")
    player03 = FactoryGirl.create(:player, :position => "SS")

    contract01 = FactoryGirl.create(:contract, :franchise_id => 1, :year => 2014, :player => player01)
    contract02 = FactoryGirl.create(:contract, :franchise_id => 1, :year => 2014, :player => player02)
    contract03 = FactoryGirl.create(:contract, :franchise_id => 1, :year => 2014, :player => player03)
    contract04 = FactoryGirl.create(:contract, :franchise_id => 1, :year => 2014, :player => player01)

    expect(Contract.under_contract_per_position(2014, 1, "1B")).to eq([contract01.player, contract04.player])
  end
end
