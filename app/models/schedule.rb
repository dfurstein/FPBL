class Schedule < ActiveRecord::Base
  attr_accessible :away_score, :away_team, :date, :extra_innings, :home_score, :home_team

  @@teams = Hash[Season.includes(:team).collect { |season| [[season.year, season.team.abbreviation.upcase], season.team] }]

  def home
    @@teams[[self.date.year, self.home_team.upcase]]
  end

  def away
    @@teams[[self.date.year, self.away_team.upcase]]
  end

  #Convert milliseconds to datetime
  def self.milliseconds_to_date(time)
    Time.at(time / 1000.0).to_datetime
  end

  #Convert milliseconds to datetime
  def self.date_to_milliseconds(date)
    (date.to_time.to_f * 1000).to_i
  end

  def self.json_for_games(from, to)
    games = Schedule.where(:date => from..to).collect{ 
      |game| {
        id: game.id,
        title: game.description,
        url: "#",
        class: "",
        start: Schedule.date_to_milliseconds(game.date),
        end: Schedule.date_to_milliseconds(game.date)
      } 
    }

    "{\"success\": 1,\"result\":" + games.to_json + "}"
  end

  def description
    if self.away.nil? or self.home.nil?
      binding.pry
    end
    "#{self.away.full_name} @ #{self.home.full_name}"
  end
end
