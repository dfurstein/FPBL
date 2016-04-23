# Describes a schedule from DMB
class Schedule < ActiveRecord::Base
  attr_accessible :date, :franchise_id_home, :score_home,
                  :franchise_id_away, :score_away,
                  :outs

  def self.update(boxscore)
    schedule = find_or_create_by_date_and_franchise_id_home(
      boxscore.date, boxscore.franchise_id_home)

    schedule.franchise_id_away = boxscore.franchise_id_away

    # The home team always pitches a full top of the inning
    if boxscore.franchise_id == boxscore.franchise_id_home
      schedule.score_away += boxscore.RA
      schedule.outs += boxscore.outs
    else
      schedule.score_home += boxscore.RA
    end

    schedule.save
  end

  def self.all_games_for_day(date)
    where(date: date).order(:id)
  end

  def self.all_games_for_month(date)
    where(date: date.beginning_of_month..date.end_of_month).order(:id)
  end

  def self.games_for_franchise(franchise_id, start_date,
      end_date = Date.new(start_date.year, 12, 31))
    where('franchise_id_home = ? OR franchise_id_away = ?', franchise_id, franchise_id)
    .where('date BETWEEN ? AND ?', start_date, end_date)
  end

  def year
    date.year
  end

  def home_team?(franchise_id)
    franchise_id_home == franchise_id
  end

  def home_team
    Team.find(year, franchise_id_home)
  end

  def away_team
    Team.find(year, franchise_id_away)
  end

  def boxscores
    Boxscore.where(date: date, franchise_id_home: franchise_id_home)
  end

  def home_win?
    score_home > score_away
  end

  def long_description
    if score_away == 0 && score_home == 0
      "#{away_team.name} at #{home_team.name}"
    else
      if home_win?
        "#{home_team.name} #{score_home}, #{away_team.name} #{score_away}"
      else
        "#{away_team.name} #{score_away}, #{home_team.name} #{score_home}"
      end
    end
  end

  def short_description
    if score_away == 0 && score_home == 0
      "#{away_team.nickname} at #{home_team.nickname}"
    else
      if home_win?
        "#{home_team.nickname} #{score_home}, #{away_team.nickname} #{score_away}"
      else
        "#{away_team.nickname} #{score_away}, #{home_team.nickname} #{score_home}"
      end
    end
  end

  def abbreviated_description
    if score_away == 0 && score_home == 0
      "#{away_team.abbreviation.upcase} at #{home_team.abbreviation.upcase}"
    else
      if home_win?
        "#{home_team.abbreviation.upcase} #{score_home}, #{away_team.abbreviation.upcase} #{score_away}"
      else
        "#{away_team.abbreviation.upcase} #{score_away}, #{home_team.abbreviation.upcase} #{score_home}"
      end
    end
  end

  def dmb_file
    "#{date.year}#{'%02d' % date.month}#{'%02d' % date.day}#{'%04d' % Team.find(date.year, home_team.franchise_id).dmb_id}0"
  end

  def extra_innings?
    outs > 27
  end

  def no_hitter?
    boxscores.group(:franchise_id).sum(:HA).values.include?(0)
  end
end
