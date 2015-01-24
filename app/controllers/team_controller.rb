# Controller to pass values to the team view
class TeamController < ApplicationController
  helper StatisticsHelper

  def index
    @franchise_id = params[:id]
    @year = Team.last.year
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

    Contract.remove_inactive_released_players(@year, @franchise_id)
  end
end
