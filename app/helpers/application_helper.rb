module ApplicationHelper

  def feed_new_or_edit
    if action_name == 'new' || action_name == 'confirm' || action_name == 'create'
      confirm_feeds_path
    elsif action_name == 'edit'
      feed_path
    end
  end

end
