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

require 'spec_helper'

describe ApprovalStatus do
  let(:default_attr){}
  
  it 'should create' do
    ApprovalStatus.create!(default_attr).states_mask.should == 1
  end
  
  describe 'approval status states' do
    let(:states) { %w[waiting rejected approved] }
    let(:approval_status) { ApprovalStatus.create(default_attr) }
    
    it 'should have the right states list' do
      ApprovalStatus::STATES.should == states
    end
    
    it 'should respond to state symbols and give the right symbols' do
      approval_status.should respond_to(:state_symbols)
      approval_status.state_symbols.should == [states.first.to_sym]
    end
    
    it 'should respond to :states and :states=' do
      approval_status.should respond_to(:states)
      approval_status.should respond_to(:states=)
    end
    
    it 'should be in waiting state by default' do
      approval_status.states.should eq(['waiting'])
    end
    
    it 'should be able to set state to different states' do
      states.each do |state|
        approval_status.states = [state]
        approval_status.states.should == [state]
      end
      
      approval_status.states = states
      approval_status.states.should == states
      approval_status.state_symbols.should == states.map(&:to_sym)
    end
    
  end
  
  describe 'comment methods' do
    let(:approval_status) { ApprovalStatus.create(default_attr) }
    
    it 'should respond to append_to_comment' do
      approval_status.should respond_to(:append_to_comment!)
    end
    
    it 'should add text to comments' do
      str1 = "here we go"
      str2 = "stop it"
      approval_status.append_to_comment!(str1)
      approval_status.comment.should == str1
      
      approval_status.append_to_comment!(str2)
      approval_status.comment.should == str1 + str2
    end
  end
end
