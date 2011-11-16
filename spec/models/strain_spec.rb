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
  
  describe 'StrainTag Association' do
    before(:each) do
      @strain = Strain.create(@attr)
      @tag = Factory(:tag)
    end
    
    it 'should respond to :strain_tags' do
      @strain.should respond_to(:strain_tags)
    end
    
    it "should respond to :tags" do
      @strain.should respond_to(:tags)
    end
    
    it 'should be able to create StrainTag association' do
      @strain.strain_tags.create(:tag_id => @tag.id)
      @strain.tags.should include(@tag)
    end
  end
  
  describe 'on destroy' do
    before(:each) do
      @strain = Strain.create(@attr)
    end
    
    it 'should be successful' do
      lambda { @strain.destroy }.should change(Strain,:count).from(1).to(0)
    end
    
    it 'should destroy StrainTag association if there is one' do
      tag = Factory(:tag)
      @strain.strain_tags.create(:tag_id => tag.id)
      lambda { @strain.destroy }.should change(StrainTag,:count).from(1).to(0)
    end
  end
end
