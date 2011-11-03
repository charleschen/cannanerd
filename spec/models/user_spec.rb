# == Schema Information
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  username           :string(255)     not null
#  email              :string(255)     not null
#  crypted_password   :string(255)     not null
#  password_salt      :string(255)     not null
#  persistence_token  :string(255)     not null
#  login_count        :integer         default(0), not null
#  failed_login_count :integer         default(0), not null
#  current_login_ip   :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

require File.dirname(__FILE__) + '/../spec_helper'

describe User do
  before(:each) do
    @attr = { :username               => "cchen",
              :email                  => 'ccchen@example.com',
              :password               => 'password',
              :password_confirmation  => 'password'
              }
  end
  
  it "should create not create a user without valid attributes" do
    User.create().should_not be_valid()
  end
  
  it "should require username" do
    User.create(@attr.merge(:username => "")).should_not be_valid
  end
  
  it "should require email" do
    User.create(@attr.merge(:email => "")).should_not be_valid
  end
  
  it "should require password" do
    User.create(@attr.merge(:password => "")).should_not be_valid
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
      User.create!(@attr.merge(:username => Faker::Name.name,:email => address))
    end
  end
  
  it "should not accept invalid email address" do
    invalid_addresses = %w{   user@foo,com 
                              THE_USER_foo.bar.org 
                              first.last@foo.}
    invalid_addresses.each do |invalid_address|
      User.create(@attr.merge(:username => Faker::Name.name,:email => invalid_address)).should_not be_valid
    end
  end

  it "should reject duplicate username" do
    User.create!(@attr)
    User.create(@attr.merge(:email => 'cc@werd.com')).should_not be_valid
  end
  
  it "should reject duplicate username up to case" do
    User.create!(@attr)
    User.create(@attr.merge(:username => @attr[:username].upcase,
                            :email => 'cc@werd.com')).should_not be_valid
  end
  
  it "should reject duplicate email accounts" do
    User.create!(@attr)
    User.create(@attr.merge(:username => 'charleschen'))
  end
  
  it "should reject duplicate email user accounts up to case" do
    User.create!(@attr)
    User.create(@attr.merge(:email => @attr[:email].upcase,
                            :username => 'charleschen')).should_not be_valid
  end
end

