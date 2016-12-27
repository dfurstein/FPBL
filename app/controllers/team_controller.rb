# Controller to pass values to the team view
class TeamController < ApplicationController
  helper StatisticsHelper

  def index
    @franchise_id = params[:id]
    @year = params[:year].nil? ? Team.last.year : params[:year].to_i
    @team = Team.find(@year, @franchise_id)
    @owner = Team.find(@year, @franchise_id).owner

    @pitchers = %w(SP MR CL)
    @hitters = %w(C 1B 2B 3B SS LF CF RF DH)

    @next_draft_year = DraftRight.pluck(:year).max
    # Remove next_draft_year from draft_years if it exists,
    # since I do not want a duplicate year to show up.
    @draft_years = Draft.pluck(:year).uniq.reverse
    @draft_years.delete(@next_draft_year)
    @current_picks = DraftRight.where(year: @next_draft_year,
                                      franchise_id_current: @franchise_id)
    @draft_selections = @draft_years.each_with_object({}) do |year, hash|
      hash[year] = Draft.where(year: year, franchise_id_current: @franchise_id)
    end

    @years = Team.pluck(:year).uniq.reverse

    @hitter_stats = Statistic.team_hitters(@year, @franchise_id, 0)
    @pitcher_stats = Statistic.team_pitchers(@year, @franchise_id, 0)
    @pitchers_as_hitters = Statistic.team_pitchers_as_hitters(@year, @franchise_id, 0)

    @hitting_totals = Statistic.team_hitting_totals(@year, @franchise_id, 0)
    @pitching_totals = Statistic.team_pitching_totals(@year, @franchise_id, 0)

    @schedule = Schedule.games_for_franchise(@franchise_id, Date.new(@year, 1, 1))
      .each_with_object({}) do |game, hash|
        if hash[game.date.month].nil?
          hash[game.date.month] = [game]
        else
          hash[game.date.month] << game
        end
      end

    Contract.remove_inactive_released_players(@year, @franchise_id)
  end
end
