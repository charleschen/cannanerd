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
#

#require File.dirname(__FILE__) + '/../spec_helper'
require 'spec_helper'
support_require 'mailer_macros'

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
  
  describe '#deliver_registration_confirmation' do
    let(:user) do
      user = User.create(@attr)  
    end#{Factory(:user)}
    
    it "should respond to :deliver_verification" do
      user.should respond_to(:deliver_registration_confirmation)
    end
    
    it "delivers email registration confirmation to user" do
      user.deliver_registration_confirmation
      last_email.to.should include(user.email)
    end
  end
  
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
  
  # describe 'answership relationship' do
  #     before(:each) do
  #       @user = User.create(@attr)
  #       @answer = Factory(:answer)
  #     end
  #     
  #     it "should respond to :answerships association" do
  #       @user.should respond_to(:answerships)
  #     end
  #     
  #     it "should respond to :answered" do
  #       @user.should respond_to(:answered)
  #     end
  #     
  #     it "should respond to :has_answered?" do
  #       @user.should respond_to(:has_answered?)
  #     end
  #     
  #     it "should include @answer in :answered after relationship created" do
  #       @user.answerships.create(:answer_id => @answer.id)
  #       @user.reload
  #       @user.should have_answered(@answer)
  #     end
  #     
  #     it "submitting answer should create answership relationship" do
  #       @user.should respond_to(:submit!)
  #       @user.submit!(@answer)
  #       @user.should have_answered(@answer)
  #     end
  #     
  #     it "unsubmitting answer should destroy relationship" do
  #       @user.should respond_to(:unsubmit!)
  #       @user.submit!(@answer)
  #       @user.unsubmit!(@answer)
  #       @user.should_not have_answered(@answer)
  #     end
  #   end
  
  describe 'RelatedTag relationship' do
    before(:each) do
      @user = Factory(:user)
      @tag = Factory(:tag)
    end
    
    it "should respond to related_tags association" do
      @user.should respond_to(:related_tags)
    end
    
    it "should respond to :tags" do
      @user.should respond_to(:tags)
    end
    
    it 'should create relationship and include tag in the relationship' do
      @user.related_tags.create(:tag_id => @tag.id)
      @user.tags.should include(@tag)
    end
  end
  
  describe 'on destroy' do
    before(:each) do
      @user = User.create(@attr)
    end
    
    it "should destroy user instance" do
      lambda {@user.destroy}.should change(User,:count).from(1).to(0)
    end
    
    it 'should destroy related_tag relationship' do
      tag = Factory(:tag)
      @user.related_tags.create(:tag_id => tag.id)
      lambda {@user.destroy}.should change(RelatedTag,:count).from(1).to(0)
    end
  end
end

