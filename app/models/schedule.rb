# Describes a schedule from DMB
class Schedule < ActiveRecord::Base
  attr_accessible :date, :franchise_id_home, :score_home,
                  :franchise_id_away, :score_away,
                  :innings

  def self.update(boxscore)
    schedule = find_or_create_by_date_and_franchise_id_home(
      boxscore.date, boxscore.franchise_id_home)

    schedule.franchise_id_away = boxscore.franchise_id_away

    # The home team always pitches a full top of the inning
    if boxscore.franchise_id == boxscore.franchise_id_home
      schedule.score_away += boxscore.RA
      schedule.innings += boxscore.IP
    else
      schedule.score_home += boxscore.RA
    end

    schedule.save
  end

  def self.games(date)
    where(date: date..date.end_of_month)
  end

  def year
    date.year
  end

  def home_team
    Team.find(year, franchise_id_home)
  end

  def away_team
    Team.find(year, franchise_id_away)
  end

  def long_description
    if score_away == 0 && score_home == 0
      "#{away_team.name} at #{home_team.name}"
    else
      "#{away_team.name} #{score_away}, #{home_team.name} #{score_home}"
    end
  end

  def short_description
    if score_away == 0 && score_home == 0
      "#{away_team.nickname} at #{home_team.nickname}"
    else
      "#{away_team.nickname} #{score_away}, #{home_team.nickname} #{score_home}"
    end
  end

  def abbreviated_description
    if score_away == 0 && score_home == 0
      "#{away_team.abbreviation.upcase} at #{home_team.abbreviation.upcase}"
    else
      "#{away_team.abbreviation.upcase} #{score_away}, #{home_team.abbreviation.upcase} #{score_home}"
    end
  end

  def dmb_file
    "#{date.year}#{'%02d' % date.month}#{'%02d' % date.day}#{'%04d' % Team.find(date.year, home_team.franchise_id).dmb_id}0"
  end
end
