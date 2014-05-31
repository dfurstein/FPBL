require 'spec_helper'

describe Performance do
  it "retrieve names of the leagues" do
    performance01 = FactoryGirl.create(:performance, :year => 2014, :league => "American", :division => "A")
    performance02 = FactoryGirl.create(:performance, :year => 2014, :league => "National", :division => "D")
    performance03 = FactoryGirl.create(:performance, :year => 2014, :league => "American", :division => "B")
    performance04 = FactoryGirl.create(:performance, :year => 2014, :league => "National", :division => "E")
    performance05 = FactoryGirl.create(:performance, :year => 2013, :league => "American", :division => "A")
    performance06 = FactoryGirl.create(:performance, :year => 2013, :league => "National", :division => "D")

    expect(Performance.leagues(2014)).to eq(["American", "National"])
  end

  it "retrieve names of the divisions" do
    performance01 = FactoryGirl.create(:performance, :year => 2014, :league => "American", :division => "A")
    performance02 = FactoryGirl.create(:performance, :year => 2014, :league => "National", :division => "D")
    performance03 = FactoryGirl.create(:performance, :year => 2014, :league => "American", :division => "B")
    performance04 = FactoryGirl.create(:performance, :year => 2014, :league => "National", :division => "E")
    performance05 = FactoryGirl.create(:performance, :year => 2013, :league => "American", :division => "A")
    performance06 = FactoryGirl.create(:performance, :year => 2013, :league => "National", :division => "D")

    expect(Performance.divisions_per_league(2014, "American")).to eq(["A", "B"])
  end

  it "retrieve performance records from a division" do
    performance01 = FactoryGirl.create(:performance, :year => 2014, :league => "American", :division => "A")
    performance02 = FactoryGirl.create(:performance, :year => 2014, :league => "National", :division => "D")
    performance03 = FactoryGirl.create(:performance, :year => 2014, :league => "American", :division => "A")
    performance04 = FactoryGirl.create(:performance, :year => 2014, :league => "National", :division => "E")
    performance05 = FactoryGirl.create(:performance, :year => 2013, :league => "American", :division => "A")
    performance06 = FactoryGirl.create(:performance, :year => 2013, :league => "National", :division => "D")

    expect(Performance.performances_per_division(2014, "American", "A")).to eq([performance01, performance03])
  end

  it "depict game streak correctly" do
    performance01 = FactoryGirl.create(:performance, :streak => 2)
    performance02 = FactoryGirl.create(:performance, :streak => -2)

    expect(performance01.game_streak).to eq("W2")
    expect(performance02.game_streak).to eq("L2")
  end

  it "depict how many games back in the division a team is" do
    performance01 = FactoryGirl.create(:performance, :year => 2014, :league => "American", :division => "A", :wins => 100)
    performance02 = FactoryGirl.create(:performance, :year => 2014, :league => "National", :division => "D", :wins => 102)
    performance03 = FactoryGirl.create(:performance, :year => 2014, :league => "American", :division => "A", :wins => 90)
    performance04 = FactoryGirl.create(:performance, :year => 2014, :league => "American", :division => "A", :wins => 100)
    performance05 = FactoryGirl.create(:performance, :year => 2013, :league => "American", :division => "A", :wins => 104)

    expect(performance01.games_back_division).to eq("-")
    expect(performance03.games_back_division).to eq(10)
    expect(performance04.games_back_division).to eq("-")
  end
end
