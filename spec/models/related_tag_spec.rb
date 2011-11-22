require 'spec_helper'

describe RelatedTag do
  let(:user) {Factory(:user)}
  let(:tag) {Factory(:tag)}
  
  it 'should not create RelatedTag without the correct associations' do
    RelatedTag.create.should_not be_valid
  end
  
  it 'should not create RelatedTag without tag association' do
    user.related_tags.create.should_not be_valid
  end
  
  it 'should create RelatedTag with correct association' do
    user.related_tags.create!(:tag_id => tag.id)
  end
  
  describe 'on destroy' do
    it 'should destroy instance' do
      related_tag = user.related_tags.create(:tag_id => tag.id)
      lambda { related_tag.destroy }.should change(RelatedTag,:count).from(1).to(0)
    end
  end
end
