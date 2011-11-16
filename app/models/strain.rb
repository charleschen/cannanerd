# == Schema Information
#
# Table name: strains
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  id_str      :string(255)
#  description :text
#  data        :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Strain < ActiveRecord::Base
  validates :name, :presence => true
  
  has_many :strain_tags, :dependent => :destroy, :foreign_key => 'strain_id'
  has_many :tags, :through => :strain_tags, :source => :tag
  
end
