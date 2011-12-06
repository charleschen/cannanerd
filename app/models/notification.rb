# == Schema Information
#
# Table name: notifications
#
#  id         :integer         not null, primary key
#  content    :text
#  unread     :boolean         default(TRUE)
#  user_id    :integer
#  redirect   :text
#  created_at :datetime
#  updated_at :datetime
#

class Notification < ActiveRecord::Base
  validates :content, :presence => true
  validates :user_id, :presence => true
  
  attr_accessible :unread, :content
  
  scope :created_order, :order => 'created_at DESC'
  scope :all_unread, where(:unread => true)
  
    # 
    # def self.unread_notififcations
    #   where("read_state ")
    # end
  
  def read!
    self.unread = false
    save
  end
end
