# == Schema Information
#
# Table name: strains
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  id_str      :string(255)
#  description :text
#  data        :text
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Strain do
  before(:all) do
    Resque.inline = true
  end
  
  after(:all) do
    Resque.inline = false
    #clear_resque(['critical','high','medium','low'])
  end
  
  before(:each) do
    Club.any_instance.stubs(:get_geocode).returns(true)
    @attr = { :name         => 'OG Kush',
              :description  => 'This is a drug'}
  end
  
  it 'should not create without the correct attributes' do
    Strain.create.should_not be_valid
  end
  
  it 'should create with the right attributes' do
    Strain.create!(@attr)
  end
  
  describe 'id_str creation according to name' do
    it 'should create the right id_str after create' do
      strain = Strain.create(@attr)
      strain.id_str.should eq('OGK_6')
    end
    
    it 'should change id_str when :name attribute is changed' do
      strain = Strain.create(@attr)
      strain.update_attribute(:name, 'white widow')
      strain.id_str.should eq('WW_10')
      
      strain.name = 'Tahoe OG'
      strain.save
      strain.id_str.should eq('TOG_7')
    end
    
    it 'should not create another strain with same id_str' do
      Strain.create(@attr)
      strain = Strain.create!(@attr).should_not be_valid
    end
  end
  
  describe 'reverse StockStrain association' do
    before(:each) do
      @strain = Strain.create(@attr)
      @club = Factory(:club)
    end
    
    it 'should respond to :reverse_stock_strains' do
      @strain.should respond_to(:reverse_stock_strains)
    end
    
    it 'should respond to :stored_in_clubs' do
      @strain.should respond_to(:stored_in_clubs)
    end
    
    it 'should create reverse association' do
      @strain.reverse_stock_strains.create(:club_id => @club.id)
      @strain.stored_in_clubs.should include(@club)
    end
  end
  
  describe 'approval status relationship' do
    let(:strain) { Strain.create(@attr) }
    
    it 'should create a approval status when creating strain' do
      lambda { strain }.should change(ApprovalStatus, :count).from(0).to(1)
      strain.approval_status.should_not be_nil
    end
  end
  
  describe 'query methods' do
    
    it 'should respond to :available_from' do
      Strain.should respond_to(:available_from)
    end
    
    it 'should return all strains from 1 club' do
      num_of_strains = 10
      
      club = Factory(:club)
      strain_array = []
      num_of_strains.times do
        strain_array <<  Factory(:strain, :name => Faker::Name.name).id
      end
      club.strains_in_inventory_ids = strain_array[0..num_of_strains-1]
      club.save
      
      strain_list = Strain.available_from([club.id])
      strain_list.count.should eq(num_of_strains)
      
      strain_array.each do |id|
        strain_list.should include(Strain.find(id))
      end
    end
    
    it 'should return no duplicates from multiple clubs' do
      num_of_strains = 100
      num_of_clubs = 5
      
      strain_array = []
      num_of_strains.times do 
        strain_array << Factory(:strain,:name => Faker::Name.name).id
      end
      
      num_of_clubs.times do |count|
        name = Faker::Name.first_name
        club = Factory(:club, :email => "#{name}@gmail.com", :name => name)
        club.strains_in_inventory_ids = strain_array[(count*5)..(10+count*5-1)]
      end
      
      strain_list = Strain.available_from(Club.all.map(&:id))
      strain_list.count.should eq(30)
      
    end
  end
  
  describe 'approval methods' do
    let(:club) { Factory(:club) }
    let(:strain) { Strain.create(@attr) }
    
    it 'should respond to approve!' do
      strain.should respond_to(:approve!)
    end
    
    it 'approve! should approve the strain' do
      strain.stubs(:approval_club_id).returns(club.id)
      
      strain.approve!
      
      strain.approval_status.states.should include('approved')
      strain.approval_status.comment.should =~ /approved by club\(:id=>#{club.id}\)/
    end
  end
  
  describe 'on destroy' do
    before(:each) do
      @strain = Strain.create(@attr)
    end
    
    it 'should be successful' do
      lambda { @strain.destroy }.should change(Strain,:count).from(1).to(0)
    end
    
    it 'should destroy approval status relationship' do
      lambda { @strain.destroy }.should change(ApprovalStatus, :count).from(1).to(0)
    end
    
    it 'should destroy reverse association' do
      StockStrain.any_instance.stubs(:destroy_all_likes).returns(true)
      
      relationship = @strain.reverse_stock_strains.create(:club_id => Factory(:club).id)
      relationship.destroy
      @strain.destroy
    end
    
  end
end
