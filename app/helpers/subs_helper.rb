module SubsHelper
  def is_moderator?(sub_topic)
    current_user.id == sub_topic.moderator.id
  end
end
