# == Schema Information
#
# Table name: approval_statuses
#
#  id              :integer         not null, primary key
#  states_mask     :integer         default(1)
#  strain_id       :integer
#  stock_strain_id :integer
#  comment         :text
#  created_at      :datetime
#  updated_at      :datetime
#

class ApprovalStatus < ActiveRecord::Base
  attr_accessible :comment
  
  STATES = %w[waiting rejected approved]
  
  def state_symbols
    states.map(&:to_sym)
  end
  
  def states
    STATES.reject{ |state| ((self.states_mask || 0) & 2**STATES.index(state)).zero? }
  end
  
  def states=(states)
    self.states_mask = (states & STATES).map { |state| 2**STATES.index(state) }.sum
    save!
  end
  
  def append_to_comment!(str)
    self.comment ||= ''
    self.comment << str
    save!
  end
end
