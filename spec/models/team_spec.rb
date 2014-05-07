require 'spec_helper'

#attr_accessible :abbreviation, :location, :nickname

#  def franchise_id

describe Team do
  it "display location and nickname together" do
    team = FactoryGirl.build(:team, :location => "New York", :nickname => "Yankees")

    expect(team.full_name).to eq("New York Yankees")
  end

  it "retrieve franchise id for a given team" do
    team01 = FactoryGirl.create(:team_with_seasons, :location => "New York", :nickname => "Yankees")
    team02 = FactoryGirl.create(:team_with_seasons, :location => "Boston", :nickname => "Red Sox")
    team03 = FactoryGirl.create(:team_with_seasons, :location => "Brooklyn", :nickname => "Dodgers")

    expect(team02.franchise_id).to eq(2)
  end
end
