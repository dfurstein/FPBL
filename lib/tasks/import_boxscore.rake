desc 'Import boxscore into Game Log'

namespace :import do
  task :boxscore, [:path] => :environment do |t, args|

    puts args[:path]

    files = Dir.glob(args[:path]).sort
    files.each do |file|
      next if file == '.' || file == '..'

      puts file

      @date = Date.today
      @franchise_id_home = -1
      @franchise_id_away = -1
      @current_franchise_id = -1

      # 0 = Do nothing
      # 1 = Load date and team names
      # 2 = Load hitter stats
      # 3 = Load pitchers stats
      # 4 = Store misc. stats
      # 5 = Load misc. stats
      @current_state = 0

      @starter = false
      @pitching_counter = 0
      additional_stats = ''

      boxscores = Hash.new

      File.open(file).each do |line|

        state = state?(line)
        @current_state = state unless state == 0

        if @current_state == 1
          state_1(line)
        elsif @current_state == 2
          state_2(boxscores, line)
        elsif @current_state == 3
          state_3(boxscores, line)
        elsif @current_state == 4
          additional_stats += state_4(line)
        elsif @current_state == 5
          state_5(boxscores, additional_stats)
          break
        end
      end

      boxscores.each do |player_id, boxscore|
        begin
          puts "Importing boxscore on #{@date} for #{Player.find(@date.year, player_id).name}"
          boxscore.save

          round = find_playoff_round(boxscore.date)

          # Only update regular season
          Standing.update(boxscore) if round == 0

          Schedule.update(boxscore)

          Statistic.update(boxscore, round)
        rescue ActiveRecord::RecordNotUnique
          puts 'Boxscore already imported'
        rescue => exception
          puts boxscore.inspect
          puts exception
        end
      end
    end
  end

  def state?(line)
    if line.include? '<pre>'
      return 1
    elsif line.include? 'AB  R  H BI   AVG'
      return 2
    elsif line.include? 'INN  H  R ER BB  K PCH STR   ERA'
      @starter = true
      @pitching_counter += 1
      return 3
    elsif %w(E- 2B- 3B- HR- RBI- SB- CS- K- BB- SF- SH- HBP- HB- WP- PB- BALK-)
            .any? { |word| line.include?(word) }
      return 4
    elsif line.include? 'Temperature:'
      return 5
    else
      return 0
    end
  end

  def state_1(line)
    stats = line.split(', ')
    return unless stats.length == 3

    @date = Date.strptime(stats[0], '%m/%d/%Y')

    @franchise_id_away = Team.franchise_id_by_abbreviation(
      @date.year, stats[1].scan(/[a-zA-Z]+/)[0])

    @franchise_id_home = Team.franchise_id_by_abbreviation(
      @date.year, stats[1].scan(/[a-zA-Z]+/)[1])

    @current_state = 0
  end

  def state_2(boxscores, line)
    regexp = /([a-zA-Z][a-zA-Z ,'\.]*\s{3,})([\w\d]{1,2})\s+([\d]+)\s+([\d]+)\s+([\d]+)\s+([\d]+)\s+([\.\d]+)/

    teams = line.scan(regexp).length

    # Determine who is the current franchise
    if teams == 1 && @current_franchise_id == -1
      @current_franchise_id =
        line.strip[0, 1].numeric? ? @franchise_id_home : @franchise_id_away
    end

    line.scan(regexp).each_with_index do |stats, index|
      player_id = Player.player_id_by_dmb_name(@date.year, stats[0].strip)

      boxscore = boxscores.fetch(player_id, Boxscore.new)

      boxscore.date = @date

      # Infer team information
      if teams == 1
        boxscore.franchise_id = @current_franchise_id
      else
        boxscore.franchise_id =
          index == 0 ? @franchise_id_away : @franchise_id_home
      end

      boxscore.franchise_id_home = @franchise_id_home
      boxscore.franchise_id_away = @franchise_id_away

      boxscore.player_id = player_id
      boxscore.position = stats[1].strip
      boxscore.AB = stats[2]
      boxscore.R = stats[3]
      boxscore.H = stats[4]
      boxscore.RBI = stats[5]

      boxscores[player_id] = boxscore
    end
  end

  def state_3(boxscores, line)
    regexp = /([a-zA-Z ,'\.]+)\s{3,}([a-zA-Z]*)(\s[\d]+,*\s)*([a-zA-Z]*)(\s[\d]+-[\d]+)*\s+([\d\.]+)\s+([\d]+)\s+([\d]+)\s+([\d]+)\s+([\d]+)\s+([\d]+)\s+([\d]+)\s+([\d]+)\s+([\d\.]+)/

    line.scan(regexp).each do |stats|
      return if stats.nil?

      player_id = Player.player_id_by_dmb_name(@date.year, stats[0].strip)

      boxscore = boxscores.fetch(player_id, Boxscore.new)
      boxscore.date = @date

      boxscore.franchise_id =
        @pitching_counter == 1 ? @franchise_id_away : @franchise_id_home
      boxscore.franchise_id_home = @franchise_id_home
      boxscore.franchise_id_away = @franchise_id_away

      boxscore.player_id = player_id
      boxscore.position = @starter ? 'SP' : 'RP'

      boxscore.W = (stats[1] == 'W' || stats[3] == 'W') ? 1 : 0
      boxscore.L = (stats[1] == 'L' || stats[3] == 'L') ? 1 : 0
      boxscore.HO = (stats[1] == 'H' || stats[3] == 'H') ? 1 : 0
      boxscore.S = (stats[1] == 'S' || stats[3] == 'S') ? 1 : 0
      boxscore.BS = (stats[1] == 'BS' || stats[3] == 'BS') ? 1 : 0

      boxscore.outs = (BigDecimal(stats[5]).truncate * 3) +
                      (BigDecimal(stats[5]).frac * 10).to_i
      boxscore.HA = stats[6]
      boxscore.RA = stats[7]
      boxscore.ER = stats[8]
      boxscore.BBA = stats[9]
      boxscore.KA = stats[10]

      boxscores[player_id] = boxscore

      @starter = false
    end
  end

  def state_4(line)
    line.strip + ' '
  end

  def state_5(boxscores, line)
    line.split("\.\s").each do |stat_line|

      stat = stat_line.partition('-').first.strip

      stat_line.partition('-').last.split(', ').each do |name|
        additional_stats(boxscores, stat, name)
      end
    end
  end

  def strip_totals_from_additional_stats(name_amount)
    if name_amount.include? '('
      return name_amount[0, name_amount.index('(')]
    else
      return name_amount
    end
  end

  def name_from_additional_stats(name_amount)
    if name_amount[-1, 1].numeric?
      return name_amount[0, name_amount.rindex(' ')]
    else
      return name_amount
    end
  end

  def amount_from_additional_stats(name_amount)
    if name_amount[-1, 1].numeric?
      index = name_amount.rindex(' ')
      return name_amount[index + 1, name_amount.length - index]
    else
      return '1'
    end
  end

  def additional_stats(boxscores, stat, name_amount)
    name_amount = strip_totals_from_additional_stats(name_amount)
    name = name_from_additional_stats(name_amount)
    amount = amount_from_additional_stats(name_amount)

    player_id = Player.player_id_by_dmb_name(@date.year, name)

    boxscore = boxscores.fetch(player_id, Boxscore.new)
    boxscore.player_id = player_id

    if stat == 'E'
      boxscore.E = amount
    elsif stat == '2B'
      boxscore.D = amount
    elsif stat == '3B'
      boxscore.T  = amount
    elsif stat == 'HR'
      boxscore.HR = amount
    elsif stat == 'RBI'
      boxscore.RBI = amount
    elsif stat == 'SB'
      boxscore.SB = amount
    elsif stat == 'CS'
      boxscore.CS = amount
    elsif stat == 'K'
      boxscore.K = amount
    elsif stat == 'BB'
      boxscore.BB = amount
    elsif stat == 'SF'
      boxscore.SF = amount
    elsif stat == 'SH'
      boxscore.SAC = amount
    elsif stat == 'HBP'
      boxscore.HBP = amount
    elsif stat == 'HB'
      boxscore.HB = amount
    elsif stat == 'WP'
      boxscore.WP = amount
    elsif stat == 'PB'
      boxscore.PB = amount
    elsif stat == 'BALK'
      boxscore.BK = amount
    elsif stat == 'CI'
      boxscore.CI = amount
    end

    boxscores[player_id] = boxscore
  end

  def find_playoff_round(date)
    case date
    when Date.new(date.year, 4, 1)..Date.new(date.year, 9, 30) then 0
    when Date.new(date.year, 10, 1)..Date.new(date.year, 10, 7) then 1
    when Date.new(date.year, 10, 8)..Date.new(date.year, 10, 17) then 2
    when Date.new(date.year, 10, 18)..Date.new(date.year, 10, 27) then 3
    else -1
    end
  end
end
