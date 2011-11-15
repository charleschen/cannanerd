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
#

class Quiziation < ActiveRecord::Base
  attr_accessible :question_id, :selected_answer_id
  attr_accessible :selected_answers_hash
  
  belongs_to :quiz
  belongs_to :question
  
  validates :quiz_id, :presence => true
  validates :question_id, :presence => true
  validates :answers_hash, :presence => true
  
  def selected_answers_hash
    hash = eval(self.answers_hash)
    hash.map {|key,val| "#{key};#{val}"}
  end
  
  def selected_answers_hash=(val)
    hash = eval(self.answers_hash)
    hash_to_merge = "{:#{val.split(';')[0]}=>#{val.split(';')[1]}}"
    hash.merge!(eval(hash_to_merge))
    hash.delete_if {|key,val| val == 0}
    
    self.answers_hash = hash.to_s
    self.save
  end
end
