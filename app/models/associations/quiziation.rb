# == Schema Information
#
# Table name: quiziations
#
#  id           :integer         not null, primary key
#  quiz_id      :integer
#  question_id  :integer
#  answers_hash :string(255)     default("{}")
#  created_at   :datetime
#  updated_at   :datetime
#  position     :integer
#

class Quiziation < ActiveRecord::Base
  attr_accessible :question_id
  attr_accessible :checked_answers,:radio_answer
  
  belongs_to :quiz
  belongs_to :question
  
  validates :quiz_id, :presence => true
  validates :question_id, :presence => true
  validates :answers_hash, :presence => true
  
  before_create :update_position
  
  def checked_answers
    answers
  end
  
  def checked_answers=(val)
    hash = eval(self.answers_hash)
    hash_to_merge = "{:#{val.split(';')[0]}=>#{val.split(';')[1]}}"
    hash.merge!(eval(hash_to_merge))
    hash.delete_if {|key,val| val == 0}
    
    self.answers_hash = hash.to_s
    self.save
  end
  
  def radio_answer
    answers.first
  end
  
  def radio_answer=(val)
    self.answers_hash = "{:#{val.split(';')[0]}=>#{val.split(';')[1]}}"
    self.save!
  end
  
  def update_position_now
    self.position = self.question.position
    save
  end
  
  private  
    def answers
      hash = eval(self.answers_hash)
      hash.map {|key,val| "#{key};#{val}"}
    end
    
    def update_position
      self.position = self.question.position
    end

end
