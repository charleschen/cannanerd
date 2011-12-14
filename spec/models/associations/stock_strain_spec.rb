# == Schema Information
#
# Table name: stock_strains
#
#  id          :integer         not null, primary key
#  club_id     :integer
#  strain_id   :integer
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#  data        :text
#  available   :boolean         default(TRUE)
#

require 'spec_helper'
require 'timecop'

describe StockStrain do
  before(:all) do
    Resque.inline = true
  end
  
  after(:all) do
    Resque.inline = false
  end
  
  let(:club) {Factory(:club)}
  
  before(:each) do
    @strain = Factory(:strain)
    Club.any_instance.stubs(:get_geocode).returns(true)
  end
  
  it 'should not create without associations' do
    StockStrain.create.should_not be_valid
  end
  
  it 'should not create without strain association' do
    
    
    club.stock_strains.create.should_not be_valid
  end
  
  it 'should create with strain association' do
    
    club.stock_strains.create!(:strain_id => @strain.id)
  end
  
  it 'available attribute should be true by default' do
    
    stock_strain = club.stock_strains.create(:strain_id => @strain.id)
    stock_strain.should be_available

    stock_strain.should respond_to(:make_unavailable!)
    stock_strain.make_unavailable!
    stock_strain.should_not be_available
    
    stock_strain.should respond_to(:make_available!)
    stock_strain.make_available!
    stock_strain.should be_available
  end
  
  describe 'approval status relationship' do
    let(:stock_strain) { club.stock_strains.create(:strain_id => @strain.id) }
    
    it 'should create approval status relationship after creation' do
      lambda { stock_strain }.should change(ApprovalStatus,:count).by(1)
      stock_strain.approval_status.should_not be_nil
    end
  end
  
  describe 'approval methods' do
    let(:stock_strain) { club.stock_strains.create(:strain_id => @strain.id) }
    
    it 'should respond to approve!' do
      stock_strain.should respond_to(:approve!)
    end
    
    it 'approve! should approve the stock_strain' do
      Timecop.freeze(Time.now)
      stock_strain
      stock_strain.approve!
      
      stock_strain.approval_status.states.should include('approved')
      stock_strain.approval_status.comment.should =~ /approved at #{Time.now.utc}/
      
      Timecop.return
    end
  end
  
  describe 'on destroy' do
    it 'should be successful' do
      StockStrain.any_instance.stubs(:destroy_all_likes).returns(true)   # so we don't need redis to destroy StockStrain
      
      association = club.stock_strains.create(:strain_id => @strain.id)
      association.destroy
    end
  end
end
