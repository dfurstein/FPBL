class PagesController < ApplicationController
  def index
    @year = 2003
  end

  def team
    @team = Season.get_current_team(params[:id])
  end
end