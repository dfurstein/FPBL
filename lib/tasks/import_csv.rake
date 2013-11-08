require 'csv'

desc "Import initial data into database from CSV file"

teams = "db/init/teams.csv"
owners = "db/init/owners.csv"
seasons = "db/init/seasons.csv"
performances = "db/init/performance.csv"

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
end
