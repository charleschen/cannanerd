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
  
  
  accepts_nested_attributes_for :answers, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
end
