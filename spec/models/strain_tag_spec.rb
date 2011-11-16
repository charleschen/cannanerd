# == Schema Information
#
# Table name: strain_tags
#
#  id         :integer         not null, primary key
#  strain_id  :integer
#  tag_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe StrainTag do
  before(:each) do
    @strain = Factory(:strain)
    @tag = Factory(:tag)
  end
  
  it "should not create without correct association" do
    StrainTag.create.should_not be_valid
  end
  
  it "should not create without tag association" do
    @strain.strain_tags.create.should_not be_valid
  end
  
  it 'should create with the correct association' do
    @strain.strain_tags.create!(:tag_id => @tag.id)
  end
  
  describe 'on destroy' do
    it 'should be successful' do
      relationship = @strain.strain_tags.create!(:tag_id => @tag.id)
      lambda {relationship.destroy}.should change(StrainTag,:count).from(1).to(0)
      
      Strain.count.should eq(1)
      Tag.count.should eq(1)
    end
  end
end
