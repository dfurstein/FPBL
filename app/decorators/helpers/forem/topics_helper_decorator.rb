Forem::TopicsHelper.class_eval do
  def link_to_latest_post(topic)
    post = topic.posts.sort_by { |p| p.updated_at }.last
    text = "#{time_ago_in_words(post.updated_at)} #{t("ago_by")} #{post.user.forem_name}"
    link_to text, forem.forum_topic_path(post.topic.forum, post.topic, :anchor => "post-#{post.id}", pagination_param => topic.last_page)
  end

  def new_since_last_view_text(topic)
    if forem_user
      topic_view = topic.view_for(forem_user)
      forum_view = topic.forum.view_for(forem_user)

      if forum_view
        if topic_view.nil? && topic.updated_at > forum_view.past_viewed_at
          "<span class='glyphicon glyphicon-star' aria-hidden='true'></span>".html_safe
        end
      end
    end
  end
end
