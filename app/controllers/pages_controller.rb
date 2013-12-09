class PagesController < ApplicationController
  def index
    @year = Season.last.year
  end

  def team
    @franchise_id = params[:id]
    @team = Season.current_team(@franchise_id)
    @owner = Season.current_owner(@franchise_id)
    @year = Season.last.year
    @pitchers = ['SP', 'MR', 'CL']
    @hitters = ['C', '1B', '2B', '3B', 'SS', 'LF', 'CF', 'RF', 'DH']
  end

  def standings
    @year = params[:year].nil? ? Season.last.year.to_s : params[:year]
    @years = Season.all.collect { |season| season.year }.uniq.reverse    
  end

  def calendar
    month = params[:month].nil? ? Date.today.month : params[:month].to_i
    year = params[:year].nil? ? Date.today.year : params[:year].to_i

    @date = Date.new(year, month, 1)
    @games = Schedule.games(@date)
  end

end