# Controller to generate an overview of all the teams
class OwnerRankingController < ApplicationController
  def index
    @ranking = Owner.all.sort_by { |owner| owner.points }.reverse!
      .map do |owner|
        Hash[ 'id' => owner.id,
              'name' => owner.name,
              'points' => owner.points,
              'teams' => owner.teams
        ]
    end
  end
end
