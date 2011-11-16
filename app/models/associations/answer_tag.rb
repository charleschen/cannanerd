# == Schema Information
#
# Table name: answer_tags
#
#  id         :integer         not null, primary key
#  answer_id  :integer
#  tag_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

class AnswerTag < ActiveRecord::Base
  attr_accessible :tag_id, :answer_id

  validates :answer_id, :presence => true
  validates :tag_id, :presence => true

  belongs_to :answer
  belongs_to :tag
  
end
