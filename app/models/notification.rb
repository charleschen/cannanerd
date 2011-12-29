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
#  club_id    :integer
#

class UserOrClubIDValidator < ActiveModel::Validator
  def validate(record)
    if record.club_id.nil? && record.user_id.nil?
      record.errors[:base] << "Must have a club or user id reference"
    end
  end
end



class Notification < ActiveRecord::Base
  validates :content, :presence => true
  #validates :user_id, :presence => true
  validates_with UserOrClubIDValidator
  
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


