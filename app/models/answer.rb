# == Schema Information
#
# Table name: answers
#
#  id          :integer         not null, primary key
#  content     :text
#  old_content :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Answer < ActiveRecord::Base
  acts_as_taggable
  
  attr_reader :tag_tokens
  validates :content, :presence => true
  
  
  has_many :reverse_questionships, :class_name => 'Questionship', :dependent=> :destroy, :foreign_key => 'answer_id'
  has_many :questions, :through => :reverse_questionships, :source => :question
end
