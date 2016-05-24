# Controller to generate an overview of all the teams
class PowerRankingController < ApplicationController
  def index
    year = Team.last.year

    @current = (1..24).each_with_object({}) do |id, rank| 
      rank[Team.find(year, id)] = Ranking.latest_elo(id).to_f
    end.sort_by { |k, v| -v }

    exp = Ranking.league_expected_win(Date.today)
    @wins = (1..24).each_with_object({}) do |id, result| 
      date = DateTime.now.hour >= 20 ? Date.today : Date.tomorrow
      result[id] = Schedule.games_for_franchise(id, date, Date.new(year,9,30))
        .map do |game| 
          exp[id][:home][game.franchise_id_away].to_f + exp[id][:away][game.franchise_id_home].to_f
        end.reduce(&:+).round
      end
  end
end