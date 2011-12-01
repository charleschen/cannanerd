class NotificationsController < ApplicationController
  filter_resource_access :nexted_in => :users
  after_filter :notifications_read
  #filter_access_to :all
  def index
    #raise params.inspect
    @notifications = current_user.notifications.created_order.limit(10)
    #@notifications.each {|n| n.read!}
  end
  
  private
    def notifications_read
      @notifications.each {|n| n.read!}
    end
end