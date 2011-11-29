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
  attr_accessible :tag_tokens, :content, :old_content
  
  validates :content, :presence => true
  
  
  has_many :reverse_questionships, :class_name => 'Questionship', :dependent=> :destroy, :foreign_key => 'answer_id'
  has_many :questions, :through => :reverse_questionships, :source => :question
  
  
  def tag_tokens=(ids)
    self.tag_list = ids
  end
end
