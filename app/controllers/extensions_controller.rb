# Controller to pass values to the view
class ExtensionsController < ApplicationController
  def index
    if current_owner.nil?
      redirect_to new_owner_session_path
    else
      @team = current_owner.most_recent_team
      @franchise_id = @team.franchise_id
      @year = @team.year
    end
  end

  def add
    @player_id = params[:player_id].to_i
    @year = params[:year].to_i
    @player = Player.find(@year, @player_id)
    @franchise_id = params[:franchise_id].to_i
    @extend_year = params[:extend_year].to_i
    @salary = params[:salary].to_f

    if current_owner.most_recent_team.franchise_id == @franchise_id
      Transaction.extend_player(@player_id, @franchise_id, @extend_year, @salary)
    end
    
    respond_to do |format|
      format.html { redirect_to extensions_path }
      format.js
    end
  end
end