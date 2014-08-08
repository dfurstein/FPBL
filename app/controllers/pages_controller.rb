# Controller to pass values to the view
class PagesController < ApplicationController
  def index
    @year = Team.last.year
  end

  def team
    @franchise_id = params[:id]
    @year = Team.last.year
    @team = Team.find(@year, @franchise_id)
    @owner = Team.find(@year, @franchise_id).owner

    @pitchers = %w(SP MR CL)
    @hitters = %w(C 1B 2B 3B SS LF CF RF DH)
  end

  def standings
    @year = params[:year].nil? ? Team.last.year.to_s : params[:year]
    @years = Team.all.map { |season| season.year }.uniq.reverse
  end

  def calendar
    month = params[:month].nil? ? Date.today.month : params[:month].to_i
    year = params[:year].nil? ? Date.today.year : params[:year].to_i

    @date = Date.new(year, month, 1)
    @games = Schedule.games(@date)
  end
end
