module ApplicationHelper

  # Returns the fill title on a per-page basis
  def full_title(page_title)
    base_title = "Favorite Pasttime Baseball League"
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  # Returns list of teams in the order they should be displayed on the standings page for a given year
  def standings(year)
    Performance.includes(:season => :team).where("year = #{year}").sort_by { 
      |performance| [performance.league, performance.division, -performance.wins] 
    }.collect { 
      |performance| performance.season.team 
    }
  end
end
