# Controller to pass values to the draft view
class DraftController < ApplicationController
  respond_to :html, :json, :js

  def index
    @year = params[:year].nil? ? Draft.last.year.to_s : params[:year]
    @years = Draft.pluck(:year).uniq.reverse

    @draft = Draft.where(year: @year)

    respond_with @draft
  end
end
