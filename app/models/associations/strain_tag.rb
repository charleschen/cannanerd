# == Schema Information
#
# Table name: strain_tags
#
#  id         :integer         not null, primary key
#  strain_id  :integer
#  tag_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

class StrainTag < ActiveRecord::Base
  attr_accessible :tag_id
  
  validates :strain_id, :presence => true
  validates :tag_id, :presence => true
  
  belongs_to :strain
  belongs_to :tag
end
