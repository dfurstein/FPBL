# Controller to pass values to the view
class ExtensionsController < ApplicationController
  def add
    @player_id = params[:player_id]
    @franchise_id = params[:franchise_id]
    @year = params[:year]
    @salary = params[:salary]

    Transaction.extend_player(@player_id, @franchise_id, @year, @salary)

    respond_to do |format|
      format.html { redirect_to extensions_path }
      format.js
    end
  end
end