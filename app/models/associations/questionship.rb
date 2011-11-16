# == Schema Information
#
# Table name: questionships
#
#  id          :integer         not null, primary key
#  answer_id   :integer
#  question_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class Questionship < ActiveRecord::Base
  attr_accessible :answer_id
  
  belongs_to :question
  belongs_to :answer
  
  validates :question_id, :presence => true
  validates :answer_id, :presence => true
end
