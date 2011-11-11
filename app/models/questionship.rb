class Questionship < ActiveRecord::Base
  attr_accessible :answer_id
  
  belongs_to :question
  belongs_to :answer
  
  validates :question_id, :presence => true
  validates :answer_id, :presence => true
end
