# == Schema Information
#
# Table name: strain_histories
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  list       :text
#  created_at :datetime
#  updated_at :datetime
#

class StrainHistory < ActiveRecord::Base
  validates :user_id, :presence => true
  validates :list, :presence => true
  
  scope :created_order, :order => ('created_at DESC')
end
