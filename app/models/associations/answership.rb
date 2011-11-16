# == Schema Information
#
# Table name: answerships
#
#  id         :integer         not null, primary key
#  answer_id  :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

class Answership < ActiveRecord::Base
  attr_accessible :answer_id
  
  belongs_to :user
  belongs_to :answer
  
  validates :user_id, :presence => true
  validates :answer_id, :presence => true
end
