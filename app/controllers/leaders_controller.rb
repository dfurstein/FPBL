# Controller to generate league leaders
class LeadersController < ApplicationController
  def season
    @year = params[:year].nil? ? Statistic.pluck(:year).uniq.last.to_s : params[:year]
    @years = (Statistic.pluck(:year).uniq.first.to_s .. Statistic.pluck(:year).uniq.last.to_s).to_a.reverse!

    @league = params[:league].nil? ? 'AL' : params[:league]
    ids = @league.upcase == 'AL' ? 1..12 : 13..24

    games = Standing.where(year: @year).first.wins + Standing.where(year: @year).first.losses

    hitters_averages = Statistic.all_hitters(@year, ids, 0, games * 3.1)
    hitters_counting = Statistic.all_hitters(@year, ids, 0, 0)
    pitchers_averages = Statistic.all_pitchers(@year, ids, 0, games)
    pitchers_counting = Statistic.all_pitchers(@year, ids, 0, 0)

    team_abbr = Team.where(year: @year).each_with_object({}) { |team, hash| hash[team.franchise_id] = team.abbreviation }
    team_abbr[0] = nil

    player_name = Player.where(year: @year).each_with_object({}) { |player, hash| hash[player.player_id] = player.name }

    @avg = hitters_averages.sort_by { |stat| -stat.AVG }.first(10)
      .map do |player|
        Hash[ 'name' => player_name[player.player_id],
              'id' => player.player_id,
              'team' => team_abbr[player.franchise_id],
              'stat' => format('%.03f', player.AVG.round(3))
        ]
      end

    @obp = hitters_averages.sort_by { |stat| -stat.OBP }.first(10)
      .map do |player|
        Hash[ 'name' => player_name[player.player_id],
              'id' => player.player_id,
              'team' => team_abbr[player.franchise_id],
              'stat' => format('%.03f', player.OBP.round(3))
        ]
      end

    @slg = hitters_averages.sort_by { |stat| -stat.SLG }.first(10)
      .map do |player|
        Hash[ 'name' => player_name[player.player_id],
              'id' => player.player_id,
              'team' => team_abbr[player.franchise_id],
              'stat' => format('%.03f', player.SLG.round(3))
        ]
      end

    @hits = hitters_counting.sort_by { |stat| -stat.H }.first(10)
      .map do |player|
        Hash[ 'name' => player_name[player.player_id],
              'id' => player.player_id,
              'team' => team_abbr[player.franchise_id],
              'stat' => player.H
        ]
      end

    @doubles = hitters_counting.sort_by { |stat| -stat.D }.first(10)
      .map do |player|
        Hash[ 'name' => player_name[player.player_id],
              'id' => player.player_id,
              'team' => team_abbr[player.franchise_id],
              'stat' => player.D
        ]
      end

    @triples = hitters_counting.sort_by { |stat| -stat.T }.first(10)
      .map do |player|
        Hash[ 'name' => player_name[player.player_id],
              'id' => player.player_id,
              'team' => team_abbr[player.franchise_id],
              'stat' => player.T
        ]
      end

    @homeruns = hitters_counting.sort_by { |stat| -stat.HR }.first(10)
      .map do |player|
        Hash[ 'name' => player_name[player.player_id],
              'id' => player.player_id,
              'team' => team_abbr[player.franchise_id],
              'stat' => player.HR
        ]
      end

    @runs = hitters_counting.sort_by { |stat| -stat.R }.first(10)
      .map do |player|
        Hash[ 'name' => player_name[player.player_id],
              'id' => player.player_id,
              'team' => team_abbr[player.franchise_id],
              'stat' => player.R
        ]
      end

    @rbis = hitters_counting.sort_by { |stat| -stat.RBI }.first(10)
      .map do |player|
        Hash[ 'name' => player_name[player.player_id],
              'id' => player.player_id,
              'team' => team_abbr[player.franchise_id],
              'stat' => player.RBI
        ]
      end

    @stolenbases = hitters_counting.sort_by { |stat| -stat.SB }.first(10)
      .map do |player|
        Hash[ 'name' => player_name[player.player_id],
              'id' => player.player_id,
              'team' => team_abbr[player.franchise_id],
              'stat' => player.SB
        ]
      end

    @era = pitchers_averages.sort_by { |stat| stat.ERA }.first(10)
      .map do |player|
        Hash[ 'name' => player_name[player.player_id],
              'id' => player.player_id,
              'team' => team_abbr[player.franchise_id],
              'stat' => format('%.02f', player.ERA.round(2))
        ]
      end

    @whip = pitchers_averages.sort_by { |stat| stat.WHIP }.first(10)
      .map do |player|
        Hash[ 'name' => player_name[player.player_id],
              'id' => player.player_id,
              'team' => team_abbr[player.franchise_id],
              'stat' => format('%.02f', player.WHIP.round(2))
        ]
      end

    @wins = pitchers_counting.sort_by { |stat| -stat.W }.first(10)
      .map do |player|
        Hash[ 'name' => player_name[player.player_id],
              'id' => player.player_id,
              'team' => team_abbr[player.franchise_id],
              'stat' => player.W
        ]
      end

    @losses = pitchers_counting.sort_by { |stat| -stat.L }.first(10)
      .map do |player|
        Hash[ 'name' => player_name[player.player_id],
              'id' => player.player_id,
              'team' => team_abbr[player.franchise_id],
              'stat' => player.L
        ]
      end

    @ip = pitchers_counting.sort_by { |stat| -stat.IP }.first(10)
      .map do |player|
        Hash[ 'name' => player_name[player.player_id],
              'id' => player.player_id,
              'team' => team_abbr[player.franchise_id],
              'stat' => player.IP
        ]
      end

    @k = pitchers_counting.sort_by { |stat| -stat.KA }.first(10)
      .map do |player|
        Hash[ 'name' => player_name[player.player_id],
              'id' => player.player_id,
              'team' => team_abbr[player.franchise_id],
              'stat' => player.KA
        ]
      end

    @saves = pitchers_counting.sort_by { |stat| -stat.S }.first(10)
      .map do |player|
        Hash[ 'name' => player_name[player.player_id],
              'id' => player.player_id,
              'team' => team_abbr[player.franchise_id],
              'stat' => player.S
        ]
      end

    @blownsaves = pitchers_counting.sort_by { |stat| -stat.BS }.first(10)
      .map do |player|
        Hash[ 'name' => player_name[player.player_id],
              'id' => player.player_id,
              'team' => team_abbr[player.franchise_id],
              'stat' => player.BS
        ]
      end

    @holds = pitchers_counting.sort_by { |stat| -stat.HO }.first(10)
      .map do |player|
        Hash[ 'name' => player_name[player.player_id],
              'id' => player.player_id,
              'team' => team_abbr[player.franchise_id],
              'stat' => player.HO
        ]
      end  
  end

  def career
    year = Statistic.pluck(:year).uniq.last
    years = (Statistic.pluck(:year).uniq.first.to_s .. Statistic.pluck(:year).uniq.last.to_s).to_a.reverse!
    ids = 1..24

    hitters_averages = Statistic.all_hitters(years, ids, 0, 2500)
    hitters_counting = Statistic.all_hitters(years, ids, 0, 1000)
    pitchers_averages = Statistic.all_pitchers(years, ids, 0, 750)
    pitchers_counting = Statistic.all_pitchers(years, ids, 0, 150)

    @avg = hitters_averages.sort_by { |stat| -stat.AVG }.first(20)
      .map do |player|
        Hash[ 'name' => player.player.name,
              'id' => player.player_id,
              'active' => player.year == year,
              'stat' => format('%.05f', player.AVG.round(5))
        ]
      end

    @obp = hitters_averages.sort_by { |stat| -stat.OBP }.first(20)
      .map do |player|
        Hash[ 'name' => player.player.name,
              'id' => player.player_id,
              'active' => player.year == year,
              'stat' => format('%.05f', player.OBP.round(5))
        ]
      end

    @slg = hitters_averages.sort_by { |stat| -stat.SLG }.first(20)
      .map do |player|
        Hash[ 'name' => player.player.name,
              'id' => player.player_id,
              'active' => player.year == year,
              'stat' => format('%.05f', player.SLG.round(5))
        ]
      end

    @hits = hitters_counting.sort_by { |stat| -stat.H }.first(20)
      .map do |player|
        Hash[ 'name' => player.player.name,
              'id' => player.player_id,
              'active' => player.year == year,
              'stat' => player.H
        ]
      end

    @doubles = hitters_counting.sort_by { |stat| -stat.D }.first(20)
      .map do |player|
        Hash[ 'name' => player.player.name,
              'id' => player.player_id,
              'active' => player.year == year,
              'stat' => player.D
        ]
      end

    @triples = hitters_counting.sort_by { |stat| -stat.T }.first(20)
      .map do |player|
        Hash[ 'name' => player.player.name,
              'id' => player.player_id,
              'active' => player.year == year,
              'stat' => player.T
        ]
      end

    @homeruns = hitters_counting.sort_by { |stat| -stat.HR }.first(20)
      .map do |player|
        Hash[ 'name' => player.player.name,
              'id' => player.player_id,
              'active' => player.year == year,
              'stat' => player.HR
        ]
      end

    @runs = hitters_counting.sort_by { |stat| -stat.R }.first(20)
      .map do |player|
        Hash[ 'name' => player.player.name,
              'id' => player.player_id,
              'active' => player.year == year,
              'stat' => player.R
        ]
      end

    @rbis = hitters_counting.sort_by { |stat| -stat.RBI }.first(20)
      .map do |player|
        Hash[ 'name' => player.player.name,
              'id' => player.player_id,
              'active' => player.year == year,
              'stat' => player.RBI
        ]
      end

    @stolenbases = hitters_counting.sort_by { |stat| -stat.SB }.first(20)
      .map do |player|
        Hash[ 'name' => player.player.name,
              'id' => player.player_id,
              'active' => player.year == year,
              'stat' => player.SB
        ]
      end

    @era = pitchers_averages.sort_by { |stat| stat.ERA }.first(20)
      .map do |player|
        Hash[ 'name' => player.player.name,
              'id' => player.player_id,
              'active' => player.year == year,
              'stat' => format('%.05f', player.ERA.round(5))
        ]
      end

    @whip = pitchers_averages.sort_by { |stat| stat.WHIP }.first(20)
      .map do |player|
        Hash[ 'name' => player.player.name,
              'id' => player.player_id,
              'active' => player.year == year,
              'stat' => format('%.05f', player.WHIP.round(5))
        ]
      end

    @wins = pitchers_counting.sort_by { |stat| -stat.W }.first(20)
      .map do |player|
        Hash[ 'name' => player.player.name,
              'id' => player.player_id,
              'active' => player.year == year,
              'stat' => player.W
        ]
      end

    @losses = pitchers_counting.sort_by { |stat| -stat.L }.first(20)
      .map do |player|
        Hash[ 'name' => player.player.name,
              'id' => player.player_id,
              'active' => player.year == year,
              'stat' => player.L
        ]
      end

    @ip = pitchers_counting.sort_by { |stat| -stat.IP }.first(20)
      .map do |player|
        Hash[ 'name' => player.player.name,
              'id' => player.player_id,
              'active' => player.year == year,
              'stat' => player.IP
        ]
      end

    @k = pitchers_counting.sort_by { |stat| -stat.KA }.first(20)
      .map do |player|
        Hash[ 'name' => player.player.name,
              'id' => player.player_id,
              'active' => player.year == year,
              'stat' => player.KA
        ]
      end

    @saves = pitchers_counting.sort_by { |stat| -stat.S }.first(20)
      .map do |player|
        Hash[ 'name' => player.player.name,
              'id' => player.player_id,
              'active' => player.year == year,
              'stat' => player.S
        ]
      end

    @blownsaves = pitchers_counting.sort_by { |stat| -stat.BS }.first(20)
      .map do |player|
        Hash[ 'name' => player.player.name,
              'id' => player.player_id,
              'active' => player.year == year,
              'stat' => player.BS
        ]
      end

    @holds = pitchers_counting.sort_by { |stat| -stat.HO }.first(20)
      .map do |player|
        Hash[ 'name' => player.player.name,
              'id' => player.player_id,
              'active' => player.year == year,
              'stat' => player.HO
        ]
      end  
  end
end