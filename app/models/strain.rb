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

require 'acts-as-taggable-on'

class Strain < ActiveRecord::Base
  acts_as_taggable
  acts_as_taggable_on :flavors, :types, :conditions, :symptoms, :effects, :prices
  
  attr_accessible :name, :flavor_tokens, :type_tokens, :condition_tokens, :symptom_tokens, :effect_tokens, :price_tokens
  attr_reader :flavor_tokens, :type_tokens, :condition_tokens, :symptom_tokens, :effect_tokens, :price_tokens
  
  #attr_reader :tag_tokens
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
  
  def self.available_from(club_id_array)
    query_array = "(#{club_id_array.map(&:to_s).join(',')})"
    query = %(SELECT strain_id FROM stock_strains WHERE club_id IN #{query_array})
    where("id IN (#{query})")
  end

  def flavor_tokens=(ids)
    self.flavor_list = ids
  end
  
  def type_tokens=(ids)
    self.type_list = ids
  end
  
  def condition_tokens=(ids)
    self.condition_list = ids
  end
  
  def symptom_tokens=(ids)
    self.symptom_list = ids
  end
  
  def effect_tokens=(ids)
    self.effect_list = ids
  end
  
  def price_tokens=(ids)
    self.price_list = ids
  end
  
  private
    def update_id_str
      self.id_str = self.name.split(/\W/).map{|w| w[0].upcase+w[1..w.length] if w.length>0 }.join.scan(/[A-Z]/).join + "_#{self.name.gsub(/\W/,"").length}"
      # str.split(/\W/).map{|w| w[0].upcase+w[1..w.length] if w.length>0 }.join.scan(/[A-Z]/).join + "_#{str.gsub(/\W/,"").length}"
    end
end
