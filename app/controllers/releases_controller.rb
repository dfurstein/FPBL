# Controller to pass values to the view
class ReleasesController < ApplicationController
  def index
    if current_owner.nil?
      redirect_to new_owner_session_path
    else
      @team = current_owner.most_recent_team
      @franchise_id = @team.franchise_id
      @year = @team.year
      @active_players = Contract.total_active_players(@year, @franchise_id) - Transaction.future_releases_count(@franchise_id)[0]
    end
  end

  def add
    @player_id = params[:player_id].to_i
    @year = params[:year].to_i
    @franchise_id = params[:franchise_id].to_i

    if current_owner.most_recent_team.franchise_id == @franchise_id
      Transaction.release_player_pending(@player_id, @franchise_id)
    end

    @active_players = Contract.total_active_players(@year, @franchise_id) - Transaction.future_releases_count(@franchise_id)[0]

    respond_to do |format|
      format.html { redirect_to releases_path }
      format.js
    end
  end

  def delete
    @player_id = params[:player_id].to_i
    @year = params[:year].to_i
    @franchise_id = params[:franchise_id].to_i

    if current_owner.most_recent_team.franchise_id == @franchise_id
      Transaction.undo_release_player_pending(@player_id, @franchise_id)
    end

    @active_players = Contract.total_active_players(@year, @franchise_id) - Transaction.future_releases_count(@franchise_id)[0]

    respond_to do |format|
      format.html { redirect_to releases_path }
      format.js
    end
  end
end