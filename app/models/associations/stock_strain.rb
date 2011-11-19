# == Schema Information
#
# Table name: stock_strains
#
#  id          :integer         not null, primary key
#  club_id     :integer
#  strain_id   :integer
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  data        :text
#  available   :boolean
#

class StockStrain < ActiveRecord::Base
  include Likeable
  
  attr_accessible :club_id, :strain_id, :description
  
  belongs_to :club
  belongs_to :strain
  
  validates :club_id, :presence => true
  validates :strain_id, :presence => true
  
  def make_available!
    self.available = true
    save
  end
  
  def make_unavailable!
    self.available = false
    save
  end
end
