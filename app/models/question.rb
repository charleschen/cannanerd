# == Schema Information
#
# Table name: questions
#
#  id               :integer         not null, primary key
#  content          :text
#  questionnaire_id :integer
#  multichoice      :boolean         default(FALSE)
#  created_at       :datetime
#  updated_at       :datetime
#  position         :integer
#

# == Schema Information
#
# Table name: questions
#
#  id               :integer         not null, primary key
#  content          :text
#  questionnaire_id :integer
#  multichoice      :boolean         default(FALSE)
#  created_at       :datetime
#  updated_at       :datetime
#
require 'acts_as_list'

class Question < ActiveRecord::Base
  acts_as_list
  attr_accessible :answers_attributes,:content, :questionnaire_id, :multichoice,:position
  
  validates :content, :presence => true
  validates :questionnaire_id, :presence => true
  
  belongs_to :questionnaire
  
  has_many :questionships, :dependent => :destroy, :foreign_key => 'question_id'
  has_many :answers, :through => :questionships, :source => :answer
  
  has_many :reverse_quiziations, :class_name => 'Quiziation', :dependent => :destroy, :foreign_key => 'question_id'
  has_many :quizzes, :through => :reverse_quiziations,  :source => :quiz
  
  accepts_nested_attributes_for :answers, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
end
