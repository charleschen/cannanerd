# == Schema Information
#
# Table name: tags
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  category   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Tag < ActiveRecord::Base
  validates :name, :presence => true
  validates :category, :presence => true
  
  has_many :reverse_answer_tags, :class_name => "AnswerTag", :dependent => :destroy, :foreign_key => 'tag_id'
  has_many :tagged_answers, :through => :reverse_answer_tags, :source => :answer
  
end
