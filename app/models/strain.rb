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
  attr_reader :tag_tokens
  validates :name, :presence => true
  
  has_many :strain_tags, :dependent => :destroy, :foreign_key => 'strain_id'
  has_many :tags, :through => :strain_tags, :source => :tag
  
  has_many :reverse_stock_strains, :class_name => 'StockStrain', :dependent => :destroy, :foreign_key => 'strain_id'
  has_many :stored_in_clubs, :through => :reverse_stock_strains, :source => :club
  
  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
  def tag_tokens=(ids)
    self.tag_ids = ids.split(',')
  end
end
