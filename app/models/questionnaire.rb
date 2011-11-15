# == Schema Information
#
# Table name: questionnaires
#
#  id         :integer         not null, primary key
#  per_page   :integer         default(4)
#  created_at :datetime
#  updated_at :datetime
#

class Questionnaire < ActiveRecord::Base
  has_many :questions
  attr_accessible :per_page, :questions_attributes
  
  accepts_nested_attributes_for :questions, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  
  def create
    if Questionnaire.count == 0
      super
    else
      Questionnaire.first
    end
  end
  
end
