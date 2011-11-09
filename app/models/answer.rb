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
  validates :content, :presence => true
  
  has_many :answer_tags, :dependent => :destroy, :foreign_key => 'answer_id'
  has_many :tags, :through => :answer_tags, :source => :tag
  
  def tag!(tag)
    self.answer_tags.create(:tag_id => tag.id)
  end
  
  def untag!(tag)
    self.answer_tags.find_by_tag_id(tag).destroy
  end
  
  def has_tag?(tag)
    !self.answer_tags.find_by_tag_id(tag).nil?
  end
end
