class PagesController < ApplicationController
  def index
    @year = Season.last.year
  end

  def team
    @team = Season.current_team(params[:id])
  end

  def standings
    @year = params[:year].nil? ? Season.last.year.to_s : params[:year]
    @years = Season.all.collect { |season| season.year }.uniq.reverse    
  end
end