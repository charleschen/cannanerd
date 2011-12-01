# == Schema Information
#
# Table name: notifications
#
#  id         :integer         not null, primary key
#  content    :text
#  read_state :integer         default(0)
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'
require 'timecop'

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
  
  describe 'class methods' do
    it 'should respond to created_order' do
      Notification.should respond_to(:created_order)
    end
    
    it 'should list notification in right order' do
      Timecop.freeze(Time.now)
      @user = user
      notification_recent = @user.notifications.create(@attr)
      Timecop.freeze(Time.now - 1.hour)
      @user.notifications.create(@attr)
      Timecop.freeze(Time.now - 2.hour)
      @user.notifications.create(@attr)
      
      @user.notifications.created_order.first.should eq(notification_recent)
      
      Timecop.return
    end
    
    it 'should respond to unread' do
      Notification.should respond_to(:all_unread)
    end
    
    it 'should return notifications that are unread' do
      @user = user
      @user.notifications.create(@attr)
      @user.notifications.create(@attr)
      notification = @user.notifications.create(@attr)
      notification.read!
      
      @user.notifications.all_unread.count.should eq(2)
      @user.notifications.all_unread.should_not include(notification)
    end
  end
  
  describe 'instance methods' do
    before(:each) do
      @notification = user.notifications.create(:content => 'harro')
    end
    
    describe 'read!' do
      it 'should respond_to' do
        @notification.should respond_to(:read!)
      end
      
      it 'should change read to true' do
        @notification.should be_unread
        @notification.read!
        @notification.should_not be_unread
      end
    end
  end
end
