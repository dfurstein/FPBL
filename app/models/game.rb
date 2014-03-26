class Game < ActiveRecord::Base
  attr_accessible :allowed_earned_run, :allowed_hit, :allowed_run, :allowed_strike_out, :allowed_walk, :at_bat, :blown_save, :caught_stealing, :date, :double, :error, :hit, :hold, :homerun, :inning, :loss, :name, :position, :run, :run_batted_in, :save, :steal, :strike_out, :team, :triple, :walk, :win

def self.load_boxscore(file)
  players = Hash.new

  File.open(file).each do |line|
    state = current_state?(line)
    print line
  end
end

def self.current_state?(line)
  if line.include? "AB  R  H BI   AVG"
    return 1
  elsif line.include? "INN  H  R ER BB  K PCH STR   ERA"
    return 2
  elsif (["E-", "2B-", "3B-", "HR-", "RBI-", "SB-", "CS-", "K-", "BB-"].any? { |word| line.include?(word) })
    return 3
  elsif line.include? "GWRBI"
    return 4
  end
end

def process_state_one(players, line)
  stats = line.split(" ")

  if stats.length == 14
    #Both teams are available
    player = players.fetch(stats[0], Player.new(stats[0]))         
    players[stats[0]] = hitter_stats(player, stats, 1)

    player = players.fetch(stats[7], Player.new(stats[7]))         
    players[stats[7]] = hitter_stats(player, stats, 8)
  elsif stats.length == 11
    #One team is available, with the other team's summary
    if stats[0].numeric?
      player = players.fetch(stats[4], Player.new(stats[4]))         
      players[stats[4]] = hitter_stats(player, stats, 5)
    else
      player = players.fetch(stats[0], Player.new(stats[0]))         
      players[stats[0]] = hitter_stats(player, stats, 1)
    end
  elsif stats.length == 7
    #One team is available
    player = players.fetch(stats[0], Player.new(stats[0]))         
    players[stats[0]] = hitter_stats(player, stats, 1)
  end
end

def process_state_two(players, line)
  stats = line.split(" ")

  if stats.length == 12
    #Pitcher has a win/loss/save/hold
    player = players.fetch(stats[0], Player.new(stats[0]))
    player.position = starter ? "SP" : "RP"
    if stats[1] == 'W'
      player.win = true
    elsif stats[1] == 'L'
      player.loss = true
    elsif stats[1] == 'S'
      player.save = true
    elsif stats[1] == 'BS'
      player.blown_save = true
    end

    players[stats[0]] = pitcher_stats(player, stats, 3)
    
    starter = false
  elsif stats.length == 10
    #Pitcher does not have one of the above
    if stats[1].numeric?
      #Make sure it isn't the header
      player = players.fetch(stats[0], Player.new(stats[0]))
      player.position = starter ? "SP" : "RP"
      players[stats[0]] = pitcher_stats(player, stats, 1)
    end
  elsif stats.length == 0
    #Next section of the boxscore
    starter = true      
    empty_lines += 1

    #Done with pitchers
    if empty_lines == 2
      state = -1
    end
  end
end

def process_state_three(players, line)
  misc_stats += line.strip + " "
end

def process_state_four(players, line)
  misc_stats.split("\.").each do |stat_line|
      stat = stat_line.partition('-').first.strip

      stat_line.partition('-').last.split(", ").each do |name|
        secondary_hitter_stats(players, stat, name)
      end
    end
  end
end

def primary_hitter_stats(player, stats, index)
  player.position = stats[index]
  player.at_bat = stats[index + 1]
  player.run = stats[index + 2]
  player.hit = stats[index + 3]
  player.run_batted_in = stats[index + 4]

  return player
end

