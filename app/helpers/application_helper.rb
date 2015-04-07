module ApplicationHelper
  # Returns the fill title on a per-page basis
  def full_title(page_title)
    base_title = 'Favorite Pastime Baseball League'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def season_disk
    Dir['public/files/*.zip'].sort_by { |file| File.mtime(file) }
      .last.partition('/').last
  end
end
