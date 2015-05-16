module PostsHelper
  def is_author?(post)
    current_user.id == post.author_id
  end
end
