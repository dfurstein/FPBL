require 'spec_helper'

#attr_accessible :email, :first_name, :last_name

describe Owner do
  it "display first and last names together" do
    owner = FactoryGirl.build(:owner, :first_name => "John", :last_name => "Smith")

    expect(owner.full_name).to eq("John Smith")
  end
end
