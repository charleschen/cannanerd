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
  attr_reader :tag_tokens
  validates :content, :presence => true
  
  has_many :answer_tags, :dependent => :destroy, :foreign_key => 'answer_id'
  has_many :tags, :through => :answer_tags, :source => :tag
  
  has_many :reverse_answerships, :class_name => 'Answership', :dependent => :destroy, :foreign_key => 'answer_id'
  has_many :responders, :through => :reverse_answerships, :source => :user
  
  has_many :reverse_questionships, :class_name => 'Questionship', :dependent=> :destroy, :foreign_key => 'answer_id'
  has_many :questions, :through => :reverse_questionships, :source => :question
  
  def tag!(tag)
    self.answer_tags.create(:tag_id => tag.id)
  end
  
  def untag!(tag)
    self.answer_tags.find_by_tag_id(tag).destroy
  end
  
  def has_tag?(tag)
    !self.answer_tags.find_by_tag_id(tag).nil?
  end
  
  def tag_tokens=(ids)
    self.tag_ids = ids.split(",")
  end
end
