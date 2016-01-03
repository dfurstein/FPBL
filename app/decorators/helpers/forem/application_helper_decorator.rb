Forem::ApplicationHelper.class_eval do
  def forem_emojify(content)
    h(content).to_str.gsub(/:([a-z0-9\+\-_]+):/) do |match|
      if Emoji.names.include?($1)
        '[img=20x20]' + asset_path("emoji/#{$1}.png") + '[/img]'
      else
        match
      end
    end.html_safe if content.present?
  end

  def forem_quote(text)
    "[quote]#{text}[/quote]\n\n".html_safe
  end
end
