class FpblPagesController < ApplicationController
  def index
  end

  def team
    @team = Season.get_current_team(params[:id])
  end
end