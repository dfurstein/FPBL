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

    Contract.remove_inactive_released_players(@year, @franchise_id)
  end
end
