require 'csv'

desc "Import initial data into database from CSV file"

teams = "db/init/teams.csv"
owners = "db/init/owners.csv"
seasons = "db/init/seasons.csv"
performances = "db/init/performance.csv"
players = "db/init/players.csv"
contracts = "db/init/contracts.csv"
schedules = "db/init/schedules.csv"

namespace :import do
  task :teams => :environment do
    CSV.foreach(teams, :headers => true) do |row|
      Team.create!(row.to_hash)
    end
  end

  task :owners => :environment do
    CSV.foreach(owners, :headers => true) do |row|
      Owner.create!(row.to_hash)
    end
  end

  task :seasons => :environment do
    CSV.foreach(seasons, :headers => true) do |row|
      Season.create!(row.to_hash)
    end
  end

  task :performances => :environment do
    CSV.foreach(performances, :headers => true) do |row|
      Performance.create!(row.to_hash)
    end
  end

  task :players => :environment do
    CSV.foreach(players, :headers => true) do |row|
      Player.create!(row.to_hash)
    end
  end

  task :contracts => :environment do
    CSV.foreach(contracts, :headers => true) do |row|
      Contract.create!(row.to_hash)
    end
  end

  task :schedules => :environment do
    CSV.foreach(schedules, :headers => true) do |row|
      Schedule.create!(row.to_hash)
    end
  end
end
