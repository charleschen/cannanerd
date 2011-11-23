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
  validates :id_str, :uniqueness => true
  
  has_many :reverse_stock_strains, :class_name => 'StockStrain', :dependent => :destroy, :foreign_key => 'strain_id'
  has_many :stored_in_clubs, :through => :reverse_stock_strains, :source => :club
  
  before_save :update_id_str, :if => :name_changed?
  
  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
  # def tag_tokens=(ids)
  #   self.tag_ids = ids.split(',')
  # end
  # 
  private
    def update_id_str
      self.id_str = self.name.split(/\W/).map{|w| w[0].upcase+w[1..w.length] if w.length>0 }.join.scan(/[A-Z]/).join + "_#{self.name.gsub(/\W/,"").length}"
      # str.split(/\W/).map{|w| w[0].upcase+w[1..w.length] if w.length>0 }.join.scan(/[A-Z]/).join + "_#{str.gsub(/\W/,"").length}"
    end
end
