# == Schema Information
#
# Table name: questions
#
#  id              :integer         not null, primary key
#  content         :text
#  questionaire_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

class Question < ActiveRecord::Base
  validates :content, :presence => true
  validates :questionaire_id, :presence => true
  
  belongs_to :questionaire
  
  has_many :questionships, :dependent => :destroy, :foreign_key => 'question_id'
  has_many :answers, :through => :questionships, :source => :answer
  
  has_many :reverse_quiziations, :class_name => 'Quiziation', :dependent => :destroy, :foreign_key => 'question_id'
  has_many :quizzes, :through => :reverse_quiziations,  :source => :quiz
  
  accepts_nested_attributes_for :answers, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
end
