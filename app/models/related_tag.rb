# == Schema Information
#
# Table name: related_tags
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  tag_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

class RelatedTag < ActiveRecord::Base
  belongs_to :user
  belongs_to :tag
  
  attr_accessible :tag_id
  
  validates :user_id, :presence => true
  validates :tag_id, :presence => true
end
