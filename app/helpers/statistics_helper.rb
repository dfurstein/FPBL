# A helper file for the team view
module StatisticsHelper
  def format_percentage_thousandths(percentage)
    return format('%.03f', 0.000) if percentage.nan?

    format('%.03f', percentage.round(3))
  end

  def format_percentage_hundredths(percentage)
    return format('%.02f', 0.00) if percentage.nan?

    format('%.02f', percentage.round(2))
  end

  def format_innings_pitched(outs)
    "#{outs / 3}.#{outs % 3}"
  end
end
