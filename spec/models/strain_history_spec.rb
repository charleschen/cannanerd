# == Schema Information
#
# Table name: strain_histories
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  list       :text
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'
require 'timecop'

describe StrainHistory do
  before(:each) do
    @attr = { :list => [{ :strain_id => 3,:rank => 3 },
                        { :strain_id => 4,:rank => 4 },
                        { :strain_id => 2,:rank => 5 },
                        { :strain_id => 63,:rank => 1 },
                        { :strain_id => 1,:rank => 6 }].to_s }
  end
  let(:user){ Factory(:user) }
  
  it 'should not be valid without correct attributes' do
    StrainHistory.create.should_not be_valid
  end
  
  it 'should not be valid without user association' do
    StrainHistory.create(@attr).should_not be_valid
  end
  
  it 'should create' do
    user.strain_histories.create!(@attr)
  end
  
  describe 'scope methods' do
    it 'should respond to :created_order and give it in the right order' do
      StrainHistory.should respond_to(:created_order)
      @user = user
      Timecop.freeze(Time.now)
      recent_strain_history = @user.strain_histories.create(@attr)
      Timecop.freeze(Time.now - 1.hour)
      @user.strain_histories.create(@attr)
      Timecop.freeze(Time.now - 2.hour)
      @user.strain_histories.create(@attr)
      
      StrainHistory.created_order.first.should eq(recent_strain_history)
      
      Timecop.return
    end
  end
end
