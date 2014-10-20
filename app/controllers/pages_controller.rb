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

  def draft
    @year = params[:year].nil? ? Draft.last.year.to_s : params[:year]
    @years = Draft.all.map { |draft| draft.year }.uniq.reverse
  end

  def transaction
    unless params[:search].nil?
      @franchise_id = params[:search][:franchise_id] unless
        params[:search][:franchise_id].to_s.strip.length == 0
      @transaction_type = params[:search][:transaction_type] unless
        params[:search][:transaction_type].to_s.strip.length == 0
      @from_date = Date.strptime(params[:search][:from_date], '%m/%d/%Y') unless
        params[:search][:from_date].to_s.strip.length == 0
      @to_date = Date.strptime(params[:search][:to_date], '%m/%d/%Y') unless
        params[:search][:to_date].to_s.strip.length == 0
    end

    @franchise_id ||= 0
    @transaction_type ||= 'ALL'
    @from_date ||= Transaction.last.processed_at.beginning_of_month.to_date
    @to_date ||= Date.today
  end
end
