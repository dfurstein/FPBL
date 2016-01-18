Forem::ForumsController.class_eval do
  def show
    register_view

    @topics = if forem_admin_or_moderator?(@forum)
      @forum.topics
    else
      @forum.topics.visible.approved_or_pending_review_for(forem_user)
    end

    @topics = @topics.sort_by { |topic| topic.posts.max_by { |post| post.updated_at }.updated_at }.reverse!

    # Kaminari allows to configure the method and param used
    @topics = Kaminari.paginate_array(@topics).page(params[pagination_param]).per(Forem.per_page)

    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
  end
end