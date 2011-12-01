module NotificationHelper
  def notifications_div
    new_notification_count = current_user.unread_notification_count
    content_tag(:div, "#{new_notification_count}", :class => 'bubble') if new_notification_count > 0
  end
  
end