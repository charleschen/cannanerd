class RelatedTag < ActiveRecord::Base
  belongs_to :user
  belongs_to :tag
  
  attr_accessible :tag_id
  
  validates :user_id, :presence => true
  validates :tag_id, :presence => true
end
