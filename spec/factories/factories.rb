# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :owner do
    sequence(:first_name) { |n| "first#{n}" }
    sequence(:last_name) { |n| "last#{n}" }

    email { "#{first_name}.#{last_name}@example.com".downcase }
  end

  factory :team do
    sequence(:abbreviation) { |n| "T#{n}" }
    sequence(:nickname) { |n| "Team#{n}" }

    location "City"
  end

  factory :team_with_seasons, :parent => :team do
    after(:create) do |team|
      FactoryGirl.create(:season, :team => team)
    end
  end

  factory :season do
    owner
    team

    sequence(:franchise_id) { |n| n }
    sequence(:owner_id) { |n| n }
    sequence(:team_id) { |n| n }

    year 2014
  end

  factory :player do
    sequence(:dmb_id) { |n| n }
    sequence(:first_name) { |n| "first#{n}" }
    sequence(:last_name) { |n| "last#{n}" }
    position "1B"
  end

  factory :contract do
    player

    sequence(:franchise_id) { |n| n }
    sequence(:player_id) { |n| n }

    release false
    salary 3.2
    year 2014
  end

  factory :performance do
    sequence(:franchise_id) { |n| n }

    league "American"
    division "Tinker"
    year 2014

    wins 100
    losses 62
    streak -2
  end
end
