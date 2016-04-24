class Ranking < ActiveRecord::Base
  self.primary_keys = :date, :franchise_id

  attr_accessible :date, :franchise_id, :ranking

  BASELINE = 1500.0
  HOME_TEAM_ADJUSTMENT = 25.0
  K = 12

  def self.latest_elo(franchise_id)
    where(franchise_id: franchise_id).pluck(:ranking).last || BASELINE
  end

  def self.previous_elo(date)
    records = ActiveRecord::Base.connection.execute(
      'SELECT r.franchise_id, r.ranking FROM rankings r ' \
      "INNER JOIN (SELECT franchise_id, max(date) AS 'date' " \
      "FROM rankings r2 WHERE r2.date < '" + date.to_s + "' GROUP BY franchise_id) tbl " \
      'ON r.franchise_id = tbl.franchise_id AND r.date = tbl.date')

    elo = Hash[*records.to_a.flatten]

    (1..24).each { |id| elo[id] = BASELINE } if elo.empty?

    elo
  end

  def self.expected_win(game, previous_elo)
    if game.opening_day?
      previous_elo[game.franchise_id_home] = ((previous_elo[game.franchise_id_home] - BASELINE) / 2.0) + BASELINE
      previous_elo[game.franchise_id_away] = ((previous_elo[game.franchise_id_away] - BASELINE) / 2.0) + BASELINE
    end

    rating_home = 10**((previous_elo[game.franchise_id_home] + HOME_TEAM_ADJUSTMENT) / 400.0)
    rating_away = 10**(previous_elo[game.franchise_id_away] / 400.0)

    expected_home = rating_home / (rating_home + rating_away)
    expected_away = rating_away / (rating_home + rating_away)

    { home: expected_home, away: expected_away }
  end

  def self.calculate_elo(game, expected_win)
    expected_home = expected_win[:home]
    expected_away = expected_win[:away]

    actual_home = game.home_win? ? 1 : 0

    home_elo = previous_elo[franchise_id_home] + K * (actual_home - expected_home)
    away_elo = previous_elo[franchise_id_away] + K * (1 - actual_home - expected_away)

    { home: home_elo, away: away_elo }
  end

  def self.save_elo(game, elo)
    create(date: game.date, franchise_id: game.franchise_id_home, ranking: elo[:home])
    create(date: game.date, franchise_id: game.franchise_id_away, ranking: elo[:away])
  end

  def self.backfill
    Schedule.where("date < '2016-4-1'").pluck(:date).uniq.each do |date| 
      previous = previous_elo(date)
      Schedule.where(date: date).each do |game|
        exp = expected_win(game, previous)
        elo = calculate_elo(game, exp)
        save_elo(game, elo)
      end
    end
  end

  def self.league_expected_win(date)
    odds = {}
    previous_elo = previous_elo(date)
    (1..24).each do |id|
      odds[id] = { home: {}, away: {} }
      (1..24).each do |opp_id|
        next if id == opp_id
        next if id < 12 && opp_id >= 12
        next if id >= 12 && opp_id < 12
        odds[id][:home][opp_id] = expected_win(id, opp_id, previous_elo, date)[:home]
        odds[id][:away][opp_id] = expected_win(opp_id, id, previous_elo, date)[:away]
      end
    end

    odds
  end

  def self.average_ranking(year, franchise_id)
    where('date BETWEEN CAST("?-01-01" AS DATE) AND CAST("?-12-31" AS DATE)', year, year)
    .where(franchise_id: franchise_id).average(:ranking)
  end
end
