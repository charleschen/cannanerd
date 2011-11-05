# == Schema Information
#
# Table name: clubs
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  crypted_password   :string(255)     not null
#  password_salt      :string(255)     not null
#  persistence_token  :string(255)     not null
#  login_count        :integer         default(0), not null
#  failed_login_count :integer         default(0), not null
#  perishable_token   :string(255)     not null
#  verified           :boolean
#  lat                :float
#  lng                :float
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

require 'spec_helper'

describe Club do
  before(:each) do
    @attr = { :name                   => "Charles Chen",
              :email                  => 'ccchen@example.com',
              :password               => 'password',
              :password_confirmation  => 'password'
              }
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
  
  describe '#verify!' do
    let(:club) {Factory(:club)}
    
    it "should respond to verify!" do
      club.should respond_to(:verify!)
    end
  
    it "change the verified attribute to true" do
      club.verify!
      club.should be_verified
    end
  end
end
