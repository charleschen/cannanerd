# == Schema Information
#
# Table name: strains
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  id_str           :string(255)
#  description      :text
#  data             :text
#  created_at       :datetime
#  updated_at       :datetime
#  approval_club_id :integer
#  club_id          :integer
#

require 'spec_helper'

describe Strain do
  before(:all) do
    Resque.inline = true
  end
  after(:all) do
    Resque.inline = false
  end
  
  let(:club) { Factory(:club) }
    
  before(:each) do
    Club.any_instance.stubs(:get_geocode).returns(true)
    @attr = { :name         => 'OG Kush',
              :description  => 'This is a drug'}
  end
  
  it 'should not create without the correct attributes' do
    Strain.create.should_not be_valid
  end
  
  it 'should not create without club reference' do
    Strain.create(@attr).should_not be_valid
  end
  
  it 'should create with the right attributes and club reference' do
    club.strains.create!(@attr)
  end
  
  describe 'id_str creation according to name' do
    let(:strain) { club.strains.create(@attr) }
    
    it 'should create the right id_str after create' do
      strain.id_str.should eq('OGK_6')
    end
    
    it 'should change id_str when :name attribute is changed' do
      strain.update_attribute(:name, 'white widow')
      strain.id_str.should eq('WW_10')
      
      strain.name = 'Tahoe OG'
      strain.save
      strain.id_str.should eq('TOG_7')
    end
    
    it 'should not create another strain with same id_str' do
      strain
      club.strains.create(@attr.merge(:name => strain.name)).should_not be_valid
    end
  end
  

  
  describe 'instance method' do
    describe 'query' do
      
      it 'should respond to :available_from' do
        Strain.should respond_to(:available_from)
      end
      
      it 'should return all strains from 1 club' do
        strain_id_array = []
        10.times do |count|
          strain_id_array << club.strains.create(:name => "#{Faker::Name.name}+#{count}").id
        end
        
        strain_list = Strain.available_from([club.id])
        strain_list.count.should == strain_id_array.count
        
        strain_id_array.each do |id|
          strain_list.should include(Strain.find(id))
        end
      end
      
      it 'should return all strains from 2 different clubs' do
        first_club = Factory(:club, :name => "MJ", :email => "mj@gmail.com")
        second_club = Factory(:club, :name => "CC", :email => "cc@gmail.com")
        
        strain_id_array = []
        10.times do |count|
          strain_id_array << first_club.strains.create(:name => "#{Faker::Name.name}+#{count}")
        end
        10.times do |count|
          strain_id_array << second_club.strains.create(:name => "#{Faker::Name.name}+#{count+10}")
        end
        
        strain_list = Strain.available_from([first_club.id,second_club.id])
        strain_list.count.should == strain_id_array.count
        
        strain_id_array.each do |id|
          strain_list.should include(Strain.find(id))
        end
      end
    end
  end
  
  describe 'on destroy' do
    before(:each) do
      @strain = club.strains.create(@attr)
    end
    
    it 'should be successful' do
      lambda { @strain.destroy }.should change(Strain,:count).from(1).to(0)
    end
  end
end
