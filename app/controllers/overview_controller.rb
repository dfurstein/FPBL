# Controller to generate an overview of all the teams
class OverviewController < ApplicationController
  def index
    year = Team.last.year

    @overview = Team.where(year: year).sort_by { |team| team.name }
    .map do |team|
      Hash[ 'id' => team.franchise_id,
            'name' => team.name,
            'owner' => team.owner.name,
            'email' => team.owner.email,
            'salary' => Contract.available_salary_cap(year, team.franchise_id).to_s,
            'players' => Contract.total_active_players(year, team.franchise_id)
      ]
    end
  end
end
