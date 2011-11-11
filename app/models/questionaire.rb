# == Schema Information
#
# Table name: questionaires
#
#  id         :integer         not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

class Questionaire < ActiveRecord::Base
  has_many :questions
  accepts_nested_attributes_for :questions, :reject_if => lambda { |a| a[:content].blank? }, :allow_destroy => true
  
  def create
    if Questionaire.count == 0
      super
    else
      Questionaire.first
    end
    
  end
  
  
end
