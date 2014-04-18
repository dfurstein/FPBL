desc "Import boxscore into Game Log"

namespace :import do
  task :boxscore, [:path] => :environment do |t, args|

    puts args[:path]

    Dir.glob(args[:path]) do |file|
      next if file == '.' or file == '..'

      puts file

      @date = Date.today
      @home_team = ''
      @away_team = ''
      @current_team = ''

      #0 = Do nothing
      #1 = Load date and team names
      #2 = Load hitter stats
      #3 = Load pitchers stats
      #4 = Store misc. stats
      #5 = Load misc. stats
      @current_state = 0

      @starter = false
      @pitching_counter = 0
      misc_stats = ""

      players = Hash.new

      File.open(file).each do |line|

        state = state?(line)
        if state != 0
          @current_state = state
        end

        if @current_state == 1
          state_1(line)
        elsif @current_state == 2
          state_2(players, line)
        elsif @current_state == 3
          state_3(players, line)
        elsif @current_state == 4
          misc_stats += state_4(line)
        elsif @current_state == 5
          state_5(players, misc_stats)
          break
        end
      end

      players.each do |player, game|
        begin
          game.save
        rescue ActiveRecord::RecordNotUnique
        rescue => ex
          puts game.inspect
          puts ex
        end
      end
    end
  end

  def state?(line)
    if line.include? "<pre>"
      return 1
    elsif line.include? "AB  R  H BI   AVG"
      return 2
    elsif line.include? "INN  H  R ER BB  K PCH STR   ERA"
      @starter = true
      @pitching_counter += 1
      return 3
    elsif (["E-", "2B-", "3B-", "HR-", "RBI-", "SB-", "CS-", "K-", "BB-", "SF-", "SH-", "HBP-", "HB-", "WP-", "PB-", "B-"].any? { |word| line.include?(word) })
      return 4
    elsif line.include? "GWRBI"
      return 5
    else
      return 0
    end
  end

  def state_1(line)
    stats = line.split(", ")

    if stats.length == 3
      @date = Date.strptime(stats[0], '%m/%d/%Y')
      @away_team = stats[1].scan(/[a-zA-Z]+/)[0]
      @home_team = stats[1].scan(/[a-zA-Z]+/)[1]

      @current_state = 0
    end
  end

  def state_2(players, line)
    regexp = /([a-zA-Z ,\.]*\s{3,})([\w\d]{1,2})\s+([\d]+)\s+([\d]+)\s+([\d]+)\s+([\d]+)\s+([\.\d]+)/

    teams = line.scan(regexp).length

    if teams == 1 and @current_team.empty?
      @current_team = line.strip[0,1].numeric? ? @home_team : @away_team
    end

    line.scan(regexp).each_with_index do |stats, index|
      player = players.fetch(stats[0].strip, Game.new)
      player.date = @date

      player.dmb_id = stats[0].strip
      player.position = stats[1].strip
      player.at_bat = stats[2]
      player.run = stats[3]
      player.hit = stats[4]
      player.run_batted_in = stats[5]

      #Infer team information
      if teams == 1
        player.team = @current_team
        player.home_or_away = @current_team == @home_team ? 'H' : 'A'
        player.played_against = @current_team == @home_team ? @away_team : @home_team
      else
        player.team = index == 0 ? @away_team : @home_team
        player.home_or_away = index == 0 ? 'A' : 'H'
        player.played_against = index == 0 ? @home_team : @away_team
      end

      players[stats[0].strip] = player
    end
  end

  def state_3(players, line)
    regexp = /([a-zA-Z ,\.]+)\s{3,}([a-zA-Z]*)(\s\d,*\s)*([a-zA-Z]*)(\s[\d]+-[\d]+)*\s+([\d\.]+)\s+([\d]+)\s+([\d]+)\s+([\d]+)\s+([\d]+)\s+([\d]+)\s+([\d]+)\s+([\d]+)\s+([\d\.]+)/

    line.scan(regexp).each do |stats|

      if stats.nil?
        return
      end

      player = players.fetch(stats[0], Game.new)
      player.date = @date
      player.team = @pitching_counter == 1 ? @away_team : @home_team
      player.played_against = @pitching_counter == 1 ? @home_team : @away_team
      player.home_or_away = @pitching_counter == 1 ? "A" : "H"
      player.dmb_id = stats[0].strip
      player.position = @starter ? "SP" : "RP"

      player.win = stats[1] == 'W' ? 1 : stats[3] == 'W' ? 1 : 0
      player.loss = stats[1] == 'L' ? 1 : stats[3] == 'L' ? 1 : 0
      player.hold = stats[1] == 'H' ? 1 : stats[3] == 'H' ? 1 : 0
      player.save_game = stats[1] == 'S' ? 1 : stats[3] == 'S' ? 1 : 0
      player.blown_save = stats[1] == 'BS' ? 1 : stats[3] == 'BS' ? 1 : 0

      player.inning = stats[5]
      player.allowed_hit = stats[6]
      player.allowed_run = stats[7]
      player.allowed_earned_run = stats[8]
      player.allowed_walk = stats[9]
      player.allowed_strike_out = stats[10]

      players[stats[0].strip] = player

      @starter = false
    end
  end

  def state_4(line)
    return line.strip + " "
  end

  def state_5(players, line)
    line.split("\.\s").each do |stat_line|

      stat = stat_line.partition('-').first.strip

      stat_line.partition('-').last.split(", ").each do |name|
        secondary_hitter_stats(players, stat, name)
      end
    end
  end

  def strip_totals_from_secondary_stats(name_amount)
    if name_amount.include? "("
      return name_amount[0, name_amount.index("(")]
    else
      return name_amount
    end
  end

  def name_from_secondary_stats(name_amount)
    if name_amount[-1, 1].numeric?
      return name_amount[0, name_amount.rindex(" ")]
    else
      return name_amount
    end
  end

  def amount_from_secondary_stats(name_amount)
    if name_amount[-1, 1].numeric?
      index = name_amount.rindex(" ")
      return name_amount[index + 1, name_amount.length - index]
    else
      return "1"
    end
  end

  def secondary_hitter_stats(players, stat, name_amount)
    name_amount = strip_totals_from_secondary_stats(name_amount)
    name = name_from_secondary_stats(name_amount)
    amount = amount_from_secondary_stats(name_amount)

    player = players.fetch(name, Game.new)
    player.dmb_id = name

    if stat == 'E'
      player.error = amount
    elsif stat == '2B'
      player.double = amount
    elsif stat == '3B'
      player.triple  = amount
    elsif stat == 'HR'
      player.homerun = amount
    elsif stat == 'RBI'
      player.run_batted_in = amount
    elsif stat == 'SB'
      player.steal = amount
    elsif stat == 'CS'
      player.caught_stealing = amount
    elsif stat == 'K'
      player.strike_out = amount
    elsif stat == 'BB'
      player.walk = amount
    elsif stat == 'SF'
      player.sacrifice_fly = amount
    elsif stat == 'SH'
      player.sacrifice = amount
    elsif stat == 'HBP'
      player.hit_by_pitch = amount
    elsif stat == 'HB'
      player.hit_batter = amount
    elsif stat == 'WP'
      player.wild_pitch = amount
    elsif stat == 'PB'
      player.passed_ball = amount
    elsif stat == 'B'
      player.balk = amount
    end

    players[name] = player
  end
end
