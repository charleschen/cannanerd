# == Schema Information
#
# Table name: quiziations
#
#  id                 :integer         not null, primary key
#  quiz_id            :integer
#  question_id        :integer
#  selected_answer_id :integer
#  created_at         :datetime
#  updated_at         :datetime
#

class Quiziation < ActiveRecord::Base
  attr_accessible :question_id, :selected_answer_id
  
  belongs_to :quiz
  belongs_to :question
  
  validates :quiz_id, :presence => true
  validates :question_id, :presence => true
end
