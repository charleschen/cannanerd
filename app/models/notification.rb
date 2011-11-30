# == Schema Information
#
# Table name: notifications
#
#  id         :integer         not null, primary key
#  content    :text
#  read       :boolean         default(FALSE)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Notification < ActiveRecord::Base
  validates :content, :presence => true
  validates :user_id, :presence => true
  
  attr_accessible :read, :content
  
end
