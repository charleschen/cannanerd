# == Schema Information
#
# Table name: clubs
#
#  id                 :integer         not null, primary key
#  email              :string(255)     not null
#  name               :string(255)     not null
#  crypted_password   :string(255)     not null
#  password_salt      :string(255)     not null
#  persistence_token  :string(255)     not null
#  login_count        :integer         default(0), not null
#  failed_login_count :integer         default(0), not null
#  perishable_token   :string(255)     not null
#  latitude           :float
#  longitude          :float
#  current_login_ip   :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  roles_mask         :integer         default(1)
#  address            :string(255)
#

require 'spec_helper'
support_require 'redis'

describe Club do
  let(:queue_list) { ['critical','high','medium','low'] }
  
  before(:each) do
    @attr = { :name                   => "Charles Chen",
              :email                  => 'ccchen@example.com',
              :password               => 'password',
              :password_confirmation  => 'password',
              :address                => '346 Laurel Avenue, California, CA'
              }
  end
  
  after(:all) do
    clear_resque(queue_list)
  end
  
  it "should create not create a club without valid attributes" do
    Club.create().should_not be_valid()
  end
  
  it "should require name" do
    Club.create(@attr.merge(:name => "")).should_not be_valid
  end
  
  it "should require password" do
    Club.create(@attr.merge(:password => "")).should_not be_valid
  end
  
  it "should require address" do
    Club.create(@attr.merge(:address => "")).should_not be_valid
  end
  
  it "should create with correct attributes" do
    Club.create!(@attr)
  end
  
  it "should require matching password and password_confirmation" do
    Club.create(@attr.merge(:password => "werd"))
  end
  
  it "should accept valid email address" do
    addresses = %w{user@foo.com THE_USER@foo.bar.org 
                    first.last@foo.jp
                    username+boobar@gmail.com
                    user-name@email.com
                    foobar@3com.com
                    foobar@foo-bar.com }
    addresses.each do |address|
      Club.create!(@attr.merge(:name => Faker::Name.name,:email => address))
    end
  end
  
  it "should not accept invalid email address" do
    invalid_addresses = %w{   user@foo,com 
                              THE_USER_foo.bar.org 
                              first.last@foo.}
    invalid_addresses.each do |invalid_address|
      Club.create(@attr.merge(:name => Faker::Name.name,:email => invalid_address)).should_not be_valid
    end
  end
  
  it "should reject accounts with duplicate name" do
    Club.create!(@attr)
    Club.create(@attr.merge(:email => 'blah@gmail.com'))
  end
  
  it "should reject accounts with duplicate name up to case" do
    Club.create!(@attr)
    Club.create(@attr.merge(:email => 'blah@gmail.com',
                            :name => @attr[:name].upcase)).should_not be_valid
  end
  
  
  it "should reject accounts with duplicate email" do
    Club.create!(@attr)
    Club.create(@attr.merge(:name => 'charleschen'))
  end
  
  it "should reject accounts with duplicate email up to case" do
    Club.create!(@attr)
    Club.create(@attr.merge(:email => @attr[:email].upcase,
                            :name => 'charleschen')).should_not be_valid
  end
  
  describe '#register!' do
    let(:club) {Factory(:club)}
    
    it "should respond to register!" do
      club.should respond_to(:register!)
    end
  
    it "change the verified attribute to true" do
      club.register!
      club.roles.should eq(['registered'])
    end
  end
  
  describe "has_many strain relationship" do
    let(:club) {Factory(:club)}
    
    it "should respond to :strains" do
      club.should respond_to(:strains)
    end
    
    it 'should be able to create strains' do
      lambda { club.strains.create(:name => "OG Kush") }.should change(Strain,:count).from(0).to(1)
    end
  end
  
  describe 'has_many notification' do
    let(:club){ Club.create(@attr) }

    it 'should respond to :notifications' do
      club.should respond_to(:notifications)
    end
    
    it 'should be able to create a notification' do
      lambda { club.notifications.create(:content => 'hello!') }.should change(Notification,:count).from(0).to(1)
    end
  end
  
  describe 'class method' do
    describe 'selection_list' do
      it 'should respond' do
        Club.should respond_to(:selection_list)
      end
      
      it 'should give the selection list of existing club' do
        club = Factory(:club)
        
        Club.selection_list.should == [[club.name,club.id]]
      end
    end
  end
  
  describe 'data methods' do
    let(:club){ Club.create(@attr) }
    let(:data_methods) { %w[phone_number hours_open]}
    
    it 'should have global variable DATA' do
      Club::DATA.should == data_methods
    end
    
    it 'should respond to getters defined by DATA' do
      data_methods.each do |method|
        club.should respond_to(method.to_sym)
      end
    end
    
    it 'should respond to setters defined by DATA' do
      data_methods.each do |method|
        club.should respond_to((method+'=').to_sym)
      end
    end
    
    it 'should be able to set and read data' do
      rand_data = []
      data_methods.count.times { rand_data << Faker::Name.first_name }
      
      data_methods.each do |method|
        data = Faker::Name.first_name
        club.send((method+'=').to_sym,data)
        
        club.send(method).should == data
      end
    end
  end
  
  describe 'roles' do
    let(:club){Club.create(@attr)}
    before(:each) do
      @roles = %w[unregistered registered]
    end
    
    it 'should have a global variable ROLES' do
      Club::ROLES.should eq(@roles)
    end
    
    it 'should respond :role_symbols and give the right roles symbol list' do
      club.should respond_to(:role_symbols)
      club.role_symbols.should eq([Club::ROLES[0].to_sym])
    end

    it 'should respond to :roles' do
      club.should respond_to(:roles)
    end
    
    it 'should not have any roles' do
      club.roles.should eq(['unregistered'])
    end
    
    it 'should respond to :roles=' do
      club.should respond_to(:roles=)
    end
    
    it 'should change roles with roles setter' do
      Club::ROLES.each do |role|
        club.roles = [role]
        club.roles.should eq([role])
      end
      
      club.roles = Club::ROLES
      club.roles.should eq(Club::ROLES)
      club.role_symbols.should eq(Club::ROLES.map(&:to_sym))
    end
  end
  
  describe 'background jobs' do
    before(:each) do
      clear_resque(queue_list)
    end
    
    it 'should have a pending job after creation' do
      Club.create(@attr)
      jobs_pending.should eq(1)
    end
  end
  
  describe 'on destroy' do
    before(:each) do
      @club = Club.create(@attr)
    end
    
    it 'should destroy the data row' do
      lambda {@club.destroy}.should change(Club,:count).from(1).to(0)
    end
    
    it 'should destroy strains associated to it' do
      @club.strains.create(:name => "whatever")
      lambda {@club.destroy}.should change(Strain,:count).from(1).to(0)
    end
    
    it 'should destroy notification association' do 
      @club.notifications.create(:content => "googog")
      lambda { @club.destroy }.should change(Notification,:count).from(1).to(0)
    end
  end
end
