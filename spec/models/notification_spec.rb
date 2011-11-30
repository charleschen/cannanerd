# == Schema Information
#
# Table name: notifications
#
#  id         :integer         not null, primary key
#  content    :text
#  read       :boolean         default(FALSE)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Notification do
  let(:user) { Factory(:user) }
  
  before(:each) do
    @attr = { :content => 'this is a notification' }
  end
  
  it 'should not create without right attributes' do
    Notification.create.should_not be_valid
  end
  
  it 'should not create without user_id' do
    Notification.create(@attr).should_not be_valid
  end
  
  it 'should create user' do
    user.notifications.create!(@attr)
  end
  
  
end
