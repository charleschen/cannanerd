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
#

require 'spec_helper'
support_require 'vcr'

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
  end
  
  it 'should not create without associations' do
    StockStrain.create.should_not be_valid
  end
  
  it 'should not create without strain association', :vcr do
    club.stock_strains.create.should_not be_valid
  end
  
  it 'should create with strain association', :vcr do
    club.stock_strains.create!(:strain_id => @strain.id)
  end
  
  describe 'on destroy', :vcr do
    it 'should be successful' do
      association = club.stock_strains.create(:strain_id => @strain.id)
      association.destroy
    end
  end
end
