require 'csv'

desc 'Import initial data into database from CSV file'

teams = 'db/init/teams.csv'
owners = 'db/init/owners.csv'
standings = 'db/init/standings.csv'
players = 'db/init/players.csv'
contracts = 'db/init/contracts.csv'
schedules = 'db/init/schedules.csv'
drafts = 'db/init/drafts.csv'
rights = 'db/init/draft_rights.csv'

namespace :import do
  task teams: :environment do
    CSV.foreach(teams, headers: true) do |row|
      Team.create!(row.to_hash)
    end
  end

  task owners: :environment do
    CSV.foreach(owners, headers: true) do |row|
      Owner.create!(row.to_hash)
    end
  end

  task standings: :environment do
    CSV.foreach(standings, headers: true) do |row|
      Standing.create!(row.to_hash)
    end
  end

  task players: :environment do
    CSV.foreach(players, headers: true) do |row|
      Player.create!(row.to_hash)
    end
  end

  task contracts: :environment do
    CSV.foreach(contracts, headers: true) do |row|
      Contract.create!(row.to_hash)
    end
  end

  task schedules: :environment do
    CSV.foreach(schedules, headers: true) do |row|
      Schedule.create!(row.to_hash)
    end
  end

  task drafts: :environment do
    CSV.foreach(drafts, headers: true) do |row|
      Draft.create!(row.to_hash)
    end
  end

  task draft_rights: :environment do
    CSV.foreach(rights, headers: true) do |row|
      DraftRight.create!(row.to_hash)
    end
  end
end
