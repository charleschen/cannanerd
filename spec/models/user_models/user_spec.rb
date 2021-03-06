# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)     not null
#  email              :string(255)     not null
#  crypted_password   :string(255)     not null
#  password_salt      :string(255)     not null
#  persistence_token  :string(255)     not null
#  login_count        :integer         default(0), not null
#  failed_login_count :integer         default(0), not null
#  perishable_token   :string(255)     not null
#  current_login_ip   :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  roles_mask         :integer         default(1)
#  zipcode            :string(255)
#  top_strains        :text
#  strain_history     :text
#  tag_list           :text
#

#require File.dirname(__FILE__) + '/../spec_helper'
require 'spec_helper'
support_require 'mailer_macros'
require 'timecop'

describe User do
  before(:each) do
    @attr = { :name                   => "Charles Chen",
              :email                  => 'ccchen@example.com',
              :password               => 'password',
              :password_confirmation  => 'password',
              :zipcode                => '91006'
              }
  end
  
  it "should create not create a user without valid attributes" do
    User.create().should_not be_valid()
  end
  
  it "should require name" do
    User.create(@attr.merge(:name => "")).should_not be_valid
  end
  
  it "should require email" do
    User.create(@attr.merge(:email => "")).should_not be_valid
  end
  
  it "should require password" do
    User.create(@attr.merge(:password => "")).should_not be_valid
  end
  
  it 'should require zipcode' do
    User.create(@attr.merge(:zipcode => nil)).should_not be_valid
  end
  
  it "should create with correct attributes" do
    User.create!(@attr)
  end
  
  it "should require matching password and password_confirmation" do
    User.create(@attr.merge(:password => "werd"))
  end
  
  it "should accept valid email address" do
    addresses = %w{user@foo.com THE_USER@foo.bar.org 
                    first.last@foo.jp
                    username+boobar@gmail.com
                    user-name@email.com
                    foobar@3com.com
                    foobar@foo-bar.com }
    addresses.each do |address|
      User.create!(@attr.merge(:name => Faker::Name.name,:email => address))
    end
  end
  
  it "should not accept invalid email address" do
    invalid_addresses = %w{   user@foo,com 
                              THE_USER_foo.bar.org 
                              first.last@foo.}
    invalid_addresses.each do |invalid_address|
      User.create(@attr.merge(:name => Faker::Name.name,:email => invalid_address)).should_not be_valid
    end
  end
  
  
  it "should reject duplicate email accounts" do
    User.create!(@attr)
    User.create(@attr.merge(:name => 'charleschen'))
  end
  
  it "should reject duplicate email user accounts up to case" do
    User.create!(@attr)
    User.create(@attr.merge(:email => @attr[:email].upcase,
                            :name => 'charleschen')).should_not be_valid
  end
  
  describe '#verify!' do
    let(:user) do
      user = User.create(@attr)  
    end#{Factory(:user)}
    
    it "should respond to verify!" do
      user.should respond_to(:verify!)
    end
  
    it "change the verified attribute to true" do
      user.verify!
      user.roles.should eq(['member'])
    end
  end
  
  describe 'instance method' do
    before(:each) do
      @user = User.create(@attr)
    end
    
    describe 'latest_picked_strain_ids' do
      it 'should respond to :latest_picked_strain_ids' do
        @user.should respond_to(:latest_picked_strain_ids)
      end
      
      it 'should return strain ids from the latest strain history' do
        strain_list = [{:strain_id => 5,:rank => 6},{:strain_id => 3,:rank => 4}]
        
        Timecop.freeze(Time.now)
        @user.strain_histories.create(:list => strain_list.to_s)
        Timecop.freeze(Time.now - 1.hour)
        @user.strain_histories.create(:list => [].to_s)
                                                
        @user.latest_picked_strain_ids.should eq(strain_list.map{|i|i[:strain_id]})
      end
    end
    
    describe 'unread_notifications' do
      it 'should respond to :unread_notifications' do
        @user.should respond_to(:unread_notification_count)
      end
      
      it 'should give out unread notifications' do
        @user.notifications.create(:content => 'unread')
        @user.notifications.create(:content => 'read').read!
        @user.notifications.create(:content => 'unread')
        
        @user.unread_notification_count.should eq(2)
      end
    end
    
    describe 'latest_answers' do 
      it 'should respond to :latest_answers' do
        @user.should respond_to(:latest_answers)
      end
  
      it 'should give the ids of answers from the latest quiz' do
        answer_ids = [1,2,3,4]
        Quiz.any_instance.stubs(:answer_ids).returns(answer_ids)
    
        quiz = Factory(:quiz)
        quiz.update_attribute(:user_id, @user.id)
    
        @user.latest_answers.should eq(answer_ids)
      end
    end
    
    describe 'init_user' do
      it 'should respond to :init_user' do
        @user.should respond_to(:init_user)
      end
    end
    
    describe 'update_tag_list!' do
      before(:each) do
        @questionnaire = Questionnaire.create
      end
      
      it 'should respond' do
        @user.should respond_to(:update_tag_list!)
      end
      
      it 'should complete' do
        quiz = Factory(:quiz)
        quiz.user_id = @user.id
        quiz.save

        @user.update_tag_list!
      end
      
      it 'should generate the right user tags' do
        answer_ids = []
        tag_list = []
        tag = Faker::Name::first_name
        5.times do
          tag = Faker::Name::first_name while(tag_list.include?(tag))
          answer = Factory(:answer)
          answer.tag_list.add(tag)
          answer.save

          answer_ids << answer.id
          tag_list << tag
        end

        User.any_instance.stubs(:latest_answers).returns(answer_ids)
        list = @user.update_tag_list!
        
        @user.reload
        tag_list.each do |tag|
          @user.tag_list.should include(tag)
        end

        tag_list.each do |tag|
          list.should include(tag)
        end

      end
    end
    
    describe 'check_and_send_top_strains' do
      let(:valid_top_strains){[ { :strain_id => 3,:rank => 6 },
                                { :strain_id => 4,:rank => 5 },
                                { :strain_id => 2,:rank => 5 },
                                { :strain_id => 6,:rank => 5 },
                                { :strain_id => 1,:rank => 4 },
                                { :strain_id => 13,:rank => 4 },
                                { :strain_id => 14,:rank => 4 },
                                { :strain_id => 12,:rank => 4 },
                                { :strain_id => 16,:rank => 4 },
                                { :strain_id => 11,:rank => 4 }].to_s }
      let(:invalid_top_strains){[{ :strain_id => 3,:rank => 1 },
                                { :strain_id => 4,:rank => 1 },
                                { :strain_id => 2,:rank => 1 },
                                { :strain_id => 6,:rank => 1 },
                                { :strain_id => 1,:rank => 1 },
                                { :strain_id => 3,:rank => 1 },
                                { :strain_id => 4,:rank => 1 },
                                { :strain_id => 2,:rank => 1 },
                                { :strain_id => 6,:rank => 1 },
                                { :strain_id => 1,:rank => 1 }].to_s }
      
      it 'should respond to :check_and_send_top_strains' do
        @user.should respond_to(:check_and_send_top_strains)
      end
      
      it 'should create a new notification if top_strains is nil' do
        User.any_instance.stubs(:top_strains).returns(nil)
        
        lambda { @user.check_and_send_top_strains }.should change(Notification,:count).from(0).to(1)
      end
      
      it 'should create notification about taking quiz again if top_strain is not valid' do
        User.any_instance.stubs(:top_strains).returns(invalid_top_strains)
        lambda { @user.check_and_send_top_strains }.should change(Notification,:count).from(0).to(1)
        @user.notifications.created_order.first.content.should =~ /retake test/
      end
      
      it 'should send mail for top strains' do
        User.any_instance.stubs(:top_strains).returns(valid_top_strains)
        Resque.inline = true
        lambda { @user.check_and_send_top_strains }.should change(StrainHistory,:count).from(0).to(1)
        Resque.inline = false
      end
    end
  end
  
  # describe '#deliver_registration_confirmation' do
  #   let(:user) do
  #     user = User.create(@attr)  
  #   end#{Factory(:user)}
  #   
  #   it "should respond to :deliver_verification" do
  #     user.should respond_to(:deliver_registration_confirmation)
  #   end
  #   
  #   it "delivers email registration confirmation to user" do
  #     user.deliver_registration_confirmation
  #     last_email.to.should include(user.email)
  #   end
  # end
  
  describe 'roles' do
    let(:user){User.create(@attr)}
    before(:each) do
      @roles = %w[unverified_member member admin]
    end
    
    it 'should have a global variable ROLES' do
      User::ROLES.should eq(@roles)
    end
    
    it 'should respond :roles_list and give the right roles symbol list' do
      user.should respond_to(:role_symbols)
      user.role_symbols.should eq([User::ROLES[0].to_sym])
    end
    
    it 'should respond to :has_role? and return true to the right role' do
      user.should respond_to(:has_role?)
      user.should have_role(User::ROLES[0])
    end

    it 'should respond to :roles' do
      user.should respond_to(:roles)
    end
    
    it 'should be unverified_member roles by default' do
      user.roles.should eq(['unverified_member'])
    end
    
    it 'should respond to :roles=' do
      user.should respond_to(:roles=)
    end
    
    it 'should change roles with roles setter' do
      User::ROLES.each do |role|
        user.roles = [role]
        user.roles.should eq([role])
      end
      
      user.roles = User::ROLES
      user.roles.should eq(User::ROLES)
      user.role_symbols.should eq(User::ROLES.map(&:to_sym))
    end
  end
  
  describe 'has_many notification' do
    let(:user){ User.create(@attr) }

    it 'should respond to :notifications' do
      user.should respond_to(:notifications)
    end
    
    it 'should be able to create a notification' do
      lambda { user.notifications.create(:content => 'hello!') }.should change(Notification,:count).from(0).to(1)
    end
  end
  
  describe "has_many strain history association" do
    let(:user){ User.create(@attr)}
    
    it 'should respond to :strain_histories' do
      user.should respond_to(:strain_histories)
    end
    
    it 'should be able to create strain_history' do
      lambda { user.strain_histories.create(:list => [{:strain_id => 1,:rank => 4}].to_s) }.should change(StrainHistory,:count).from(0).to(1)
    end
  end

  
  describe 'on destroy' do
    before(:each) do
      @user = User.create(@attr)
    end
    
    it "should destroy user instance" do
      lambda {@user.destroy}.should change(User,:count).from(1).to(0)
    end
    
    it 'should destroy notification association' do 
      @user.notifications.create(:content => "googog")
      lambda { @user.destroy }.should change(Notification,:count).from(1).to(0)
    end
    
    it 'should destroy strain history association' do
      @user.strain_histories.create(:list => [{:strain_id => 1,:rank => 4}].to_s)
      lambda { @user.destroy }.should change(StrainHistory,:count).from(1).to(0)
    end
  end
end

