desc "Import boxscore into Game Log"

namespace :import do
  task :boxscore, [:file] => :environment do |t, args|
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


    File.open(args[:file]).each do |line|

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
      end
    end

    players.each do |player, game|
      game.save
    end
  end
end

def state?(line)
  if line.include? "<pre>"
    return 1
  elsif line.include? "AB  R  H BI   AVG"
    return 2
  elsif line.include? "INN  H  R ER BB  K PCH STR   ERA"
    @pitching_counter += 1
    @starter = true
    return 3
  elsif (["E-", "2B-", "3B-", "HR-", "RBI-", "SB-", "CS-", "K-", "BB-"].any? { |word| line.include?(word) })
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
  stats = line.split(" ")

  if stats.length == 14
    #Both teams are available
    player = players.fetch(stats[0], Game.new)
    player.date = @date
    player.team = @away_team
    players[stats[0]] = primary_hitter_stats(player, stats, 0)

    player = players.fetch(stats[7], Game.new)
    player.date = @date
    player.team = @home_team
    players[stats[7]] = primary_hitter_stats(player, stats, 7)
  elsif stats.length == 11
    #One team is available, with the other team's summary
    if stats[0].numeric?
      player = players.fetch(stats[4], Game.new)
      player.date = @date
      player.team = @home_team
      players[stats[4]] = primary_hitter_stats(player, stats, 4)

      @current_team = @home_team
    else
      player = players.fetch(stats[0], Game.new)
      player.date = @date
      player.team = @away_team
      players[stats[0]] = primary_hitter_stats(player, stats, 0)

      @current_team = @away_team
    end
  elsif stats.length == 7
    #One team is available
    player = players.fetch(stats[0], Game.new)
    player.date = @date
    player.team = @current_team
    players[stats[0]] = primary_hitter_stats(player, stats, 0)
  end
end

def state_3(players, line)
  stats = line.split(" ")

  if stats.length == 12
    #Pitcher has a win/loss/save/hold
    player = players.fetch(stats[0], Game.new)
    player.date = @date
    player.team = @pitching_counter == 1 ? @away_team : @home_team
    player.dmb_id = stats[0]
    player.position = @starter ? "SP" : "RP"

    player.win = stats[1] == 'W'
    player.loss = stats[1] == 'L'
    player.hold = stats[1] == 'H'
    player.save_game = stats[1] == 'S'
    player.blown_save = stats[1] == 'BS'

    players[stats[0]] = primary_pitcher_stats(player, stats, 3)

    @starter = false
  elsif stats.length == 10
    #Pitcher does not have one of the above
    if stats[1].numeric?
      #Make sure it isn't the header
      player = players.fetch(stats[0], Game.new)
      player.date = @date
      player.team = @pitching_counter == 1 ? @away_team : @home_team
      player.dmb_id = stats[0]
      player.position = @starter ? "SP" : "RP"

      players[stats[0]] = primary_pitcher_stats(player, stats, 1)

      @starter = false
    end
  end
end

def state_4(line)
  return line.strip + " "
end

def state_5(players, line)
  line.split("\.").each do |stat_line|
    stat = stat_line.partition('-').first.strip

    stat_line.partition('-').last.split(", ").each do |name|
      secondary_hitter_stats(players, stat, name)
    end
  end
end

def primary_hitter_stats(player, stats, index)
  player.dmb_id = stats[index]
  player.position = stats[index + 1]
  player.at_bat = stats[index + 2]
  player.run = stats[index + 3]
  player.hit = stats[index + 4]
  player.run_batted_in = stats[index + 5]

  return player
end

def primary_pitcher_stats(player, stats, index)
  player.inning = stats[index]
  player.allowed_hit = stats[index + 1]
  player.allowed_run = stats[index + 2]
  player.allowed_earned_run = stats[index + 3]
  player.allowed_walk = stats[index + 4]
  player.allowed_strike_out = stats[index + 5]

  return player
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
  end

  players[name] = player
end
