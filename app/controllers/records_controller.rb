# Controller to generate league records
class RecordsController < ApplicationController
  def index
    @year = params[:year].nil? ? Boxscore.last.date.year.to_s : params[:year]
    @years = (Boxscore.first.date.year.to_s .. Boxscore.last.date.year.to_s).to_a.reverse!
  
    @pitcher_scores = Boxscore.where("position = 'SP' AND YEAR(date) = #{@year}")
    .sort_by { |boxscore| -boxscore.game_score }.first(20)
    .map do |boxscore|
      Hash[ 'pitcher' => Player.find(boxscore.date.year, boxscore.player_id).name,
            'team' => Team.find(boxscore.date.year, boxscore.franchise_id).abbreviation,
            'date' => boxscore.date,
            'score' => Schedule.where(date: boxscore.date, franchise_id_home: boxscore.franchise_id_home).first.abbreviated_description,
            'IP' => boxscore.outs,
            'H' => boxscore.HA,
            'R' => boxscore.RA,
            'ER' => boxscore.ER,
            'BB' => boxscore.BBA,
            'SO' => boxscore.KA,
            'decision' => boxscore.W == 1 ? 'W' : boxscore.L == 1 ? 'L' : 'ND',
            'gamescore' => boxscore.game_score,
            'boxscore' => Schedule.where(date: boxscore.date, franchise_id_home: boxscore.franchise_id_home).first
      ]
    end

    @hitter_scores = Boxscore.where("AB >= 3 AND H >= 2 AND R >= 1 AND RBI >= 2 AND YEAR(date) = #{@year}")
    .sort_by { |boxscore| -boxscore.espn_score }.first(20)
    .map do |boxscore|
      Hash[ 'hitter' => Player.find(boxscore.date.year, boxscore.player_id).name,
            'team' => Team.find(boxscore.date.year, boxscore.franchise_id).abbreviation,
            'date' => boxscore.date,
            'score' => Schedule.where(date: boxscore.date, franchise_id_home: boxscore.franchise_id_home).first.abbreviated_description,
            'AB' => boxscore.AB,
            'R' => boxscore.R,
            'H' => boxscore.H,
            '2B' => boxscore.D,
            '3B' => boxscore.T,
            'HR' => boxscore.HR,
            'RBI' => boxscore.RBI,
            'SB' => boxscore.SB,
            'gamescore' => boxscore.espn_score,
            'boxscore' => Schedule.where(date: boxscore.date, franchise_id_home: boxscore.franchise_id_home).first
      ]
    end
  end
end
