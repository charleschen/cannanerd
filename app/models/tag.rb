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
  
  attr_accessible :name, :category
  
  validates :name, :presence => true, :uniqueness => {:case_sensitive => false}
  validates :category, :presence => true
  
  has_many :reverse_answer_tags, :class_name => "AnswerTag", :dependent => :destroy, :foreign_key => 'tag_id'
  has_many :tagged_answers, :through => :reverse_answer_tags, :source => :answer
  
  has_many :reverse_strain_tags, :class_name => 'StrainTag', :dependent => :destroy, :foreign_key => 'tag_id'
  has_many :tagged_strains, :through => :reverse_strain_tags, :source => :strain

end
