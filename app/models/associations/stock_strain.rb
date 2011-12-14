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
#  available   :boolean         default(TRUE)
#

class StockStrain < ActiveRecord::Base
  include Likeable
  
  attr_accessible :club_id, :strain_id, :description
  
  belongs_to :club
  belongs_to :strain
  
  validates :club_id, :presence => true
  validates :strain_id, :presence => true
  
  has_one :approval_status, :dependent => :destroy
  
  after_create :create_approval_status
  
  def make_available!
    self.available = true
    save
  end
  
  def make_unavailable!
    self.available = false
    save
  end
  
  def approve!
    self.approval_status.states = ['approved']
    self.approval_status.append_to_comment!("approved at #{Time.now.utc};")
  end
  
  private
    def create_approval_status
      self.approval_status = ApprovalStatus.create
    end
end
