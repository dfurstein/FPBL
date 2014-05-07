require 'spec_helper'

#attr_accessible :franchise_id, :owner_id, :team_id, :year, :dmb_id

describe Season do
  it "retrieve the most current team for a franchise" do
    season01 = FactoryGirl.create(:season, :franchise_id => 1, :year => 2014)
    season02 = FactoryGirl.create(:season, :franchise_id => 2, :year => 2014)
    season03 = FactoryGirl.create(:season, :franchise_id => 1, :year => 2013)

    expect(Season.current_team(1)).to eq(season01.team)
  end

  it "retrieve the most current owner for a franchise" do
    season01 = FactoryGirl.create(:season, :franchise_id => 1, :year => 2014)
    season02 = FactoryGirl.create(:season, :franchise_id => 2, :year => 2014)
    season03 = FactoryGirl.create(:season, :franchise_id => 1, :year => 2013)

    expect(Season.current_owner(1)).to eq(season01.owner)
  end

  it "retrieve list of current teams" do
    season01 = FactoryGirl.create(:season, :franchise_id => 1, :year => 2014)
    season02 = FactoryGirl.create(:season, :franchise_id => 2, :year => 2014)
    season03 = FactoryGirl.create(:season, :franchise_id => 1, :year => 2013)

    expect(Season.current_teams).to eq([season01.team, season02.team])
  end
end
