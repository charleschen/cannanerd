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
end
