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
support_require 'vcr'
support_require 'redis'

describe Strain do
  before(:all) do
    Resque.inline = true
  end
  
  after(:all) do
    Resque.inline = false
    #clear_resque(['critical','high','medium','low'])
  end
  
  before(:each) do
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
    
    it 'should respond to :reverse_stock_strains', :vcr do
      @strain.should respond_to(:reverse_stock_strains)
    end
    
    it 'should respond to :stored_in_clubs', :vcr do
      @strain.should respond_to(:stored_in_clubs)
    end
    
    it 'should create reverse association', :vcr do
      @strain.reverse_stock_strains.create(:club_id => @club.id)
      @strain.stored_in_clubs.should include(@club)
    end
  end
  
  describe 'on destroy' do
    before(:each) do
      @strain = Strain.create(@attr)
    end
    
    it 'should be successful' do
      lambda { @strain.destroy }.should change(Strain,:count).from(1).to(0)
    end
    
    it 'should destroy reverse association', :vcr do
      relationship = @strain.reverse_stock_strains.create(:club_id => Factory(:club).id)
      relationship.destroy
      @strain.destroy
      #lambda {@strain.destroy}.should change(StockStrain,:count).from(1).to(0)
    end
  end
end
