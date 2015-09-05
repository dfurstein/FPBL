# Controller to generate an overview of all the teams
class PlayerController < ApplicationController
  def index
    id = params[:id]

    @player = Player.where(player_id: id).order(:year).last
    @first_season = Player.where(player_id: id).pluck(:year).sort.first

    @hitting_stats = Statistic.where(player_id: id).map { |x| x.PA }.sum > 0
    @pitching_stats = Statistic.where(player_id: id).sum(:outs) > 0

    @regular_season_stats = Statistic.where(player_id: id, playoff_round: 0).order(:year)
    @regular_season_hitting_totals = Statistic.player_career_hitting_totals(id, 0)
    @regular_season_pitching_totals = Statistic.player_career_pitching_totals(id, 0)

    @divisional_series_stats = Statistic.where(player_id: id, playoff_round: 1).order(:year)
    @divisional_series_hitting_totals = Statistic.player_career_hitting_totals(id, 1)
    @divisional_series_pitching_totals = Statistic.player_career_pitching_totals(id, 1)

    @league_series_stats = Statistic.where(player_id: id, playoff_round: 2).order(:year)
    @league_series_hitting_totals = Statistic.player_career_hitting_totals(id, 2)
    @league_series_pitching_totals = Statistic.player_career_pitching_totals(id, 2)

    @championship_series_stats = Statistic.where(player_id: id, playoff_round: 3).order(:year)
    @championship_series_hitting_totals = Statistic.player_career_hitting_totals(id, 3)
    @championship_series_pitching_totals = Statistic.player_career_pitching_totals(id, 3)
  end
end
