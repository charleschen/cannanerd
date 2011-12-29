# == Schema Information
#
# Table name: strains
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  id_str           :string(255)
#  description      :text
#  data             :text
#  created_at       :datetime
#  updated_at       :datetime
#  approval_club_id :integer
#  club_id          :integer
#

require 'acts-as-taggable-on'

class Strain < ActiveRecord::Base
  acts_as_taggable
  acts_as_taggable_on :flavors, :types, :conditions, :symptoms, :effects, :prices
  
  attr_accessible :name, :approval_club_id, :description, :flavor_tokens, :type_tokens, :condition_tokens, :symptom_tokens, :effect_tokens, :price_tokens, :club_id
  attr_reader :flavor_tokens, :type_tokens, :condition_tokens, :symptom_tokens, :effect_tokens, :price_tokens
    
  #attr_reader :tag_tokens
  validates :club_id, :presence => true
  validates :name, :presence => true
  validates :id_str, :uniqueness => { :scope => :club_id, :message => "strains should be unique in each club" }
  
  scope :recently_created, :order => 'created_at DESC'
  
  # has_many :reverse_stock_strains, :class_name => 'StockStrain', :dependent => :destroy, :foreign_key => 'strain_id'
  # has_many :stored_in_clubs, :through => :reverse_stock_strains, :source => :club
  
  belongs_to :club
  has_one :approval_status, :dependent => :destroy
  
  before_save :update_id_str, :if => :name_changed?
  after_create :create_apporval_status
  
  def self.search(search)
    if search
      where('name LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
  def self.available_from(club_id_array)
    query_array = "(#{club_id_array.map(&:to_s).join(',')})"
    #query = %(SELECT strain_id FROM stock_strains WHERE club_id IN #{query_array})
    #query = %(SELECT strain_id FROM strains WHERE club_id IN #{query_array})
    #where("id IN (#{query})")
    where("club_id in #{query_array}")
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
  
  def approve!
    raise NoApprovalClubIdError, "Tried to approve strain without club id, it should be impossible to do this" if self.club_id.nil?
    self.approval_status.states = ['approved']
    self.approval_status.append_to_comment!("approved by club(:id=>#{self.approval_club_id}) at #{Time.now.utc.to_s};")
  end
  
  private
    def update_id_str
      self.id_str = self.name.split(/\W/).map{|w| w[0].upcase+w[1..w.length] if w.length>0 }.join.scan(/[A-Z]/).join + "_#{self.name.gsub(/\W/,"").length}"
      #!Strain.find_by_id_str(self.id_str)
      #self.valid?
    end
    
    def create_apporval_status
      self.approval_status = ApprovalStatus.create
    end
end
