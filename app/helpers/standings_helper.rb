# A helper file for the standings view
module StandingsHelper
  def format_win_percentage(win_percentage)
    return format('%.03f', 0.000) if win_percentage.nan?

    format('%.03f', win_percentage.round(3))
  end

  def format_game_streak(streak)
    return '-' if streak == 0

    streak > 0 ?  "W#{streak}" : "L#{streak.abs}"
  end

  def format_games_back(games_back)
    games_back == 0 ? '-' : games_back
  end
end
