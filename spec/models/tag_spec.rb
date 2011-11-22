# == Schema Information
#
# Table name: tags
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  category   :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Tag do
  before(:each) do
    @attr = {:name => 'indica', :category => 'strain'}
  end
  
  it "should not create without the correct attributes" do
    Tag.create().should_not be_valid
  end
  
  it "should create with the right attributes" do
    Tag.create!(@attr)
  end
  
  describe 'answer relationship' do
    before(:each) do
      @tag = Tag.create!(@attr)
      @answer = Factory(:answer)
    end

    it 'should respond to :reverse_answer_tags association' do
      @tag.should respond_to(:reverse_answer_tags)
    end

    it 'should respond to :tagged_answers' do
      @tag.should respond_to(:tagged_answers)
    end

    it 'should include tag in :tags with the association created' do
      lambda do
        @tag.reverse_answer_tags.create!(:answer_id => @answer.id)
      end.should change(AnswerTag,:count).by(1)
      @tag.tagged_answers.should include(@answer)
    end
  end
  
  describe 'StrainTag relationship' do
    before(:each) do
      @tag = Tag.create(@attr)
      @strain = Factory(:strain)
    end
    
    it 'should respond to :reverse_strain_tags' do
      @tag.should respond_to(:reverse_strain_tags)
    end
    
    it 'should respond to :tagged_strains' do
      @tag.should respond_to(:tagged_strains)
    end
    
    it 'should have association with StrainTags' do
      @strain.strain_tags.create(:tag_id => @tag.id)
      @tag.tagged_strains.should include(@strain)
    end
  end
  
  describe 'reverse related_tag relationship' do
    before(:each) do
      @tag = Tag.create(@attr)
      @user = Factory(:user)
    end
    
    it 'should respond to :reverse_related_tags' do
      @tag.should respond_to(:reverse_related_tags)
    end
    
    it 'should respond to :tagged_by_users' do
      @tag.should respond_to(:tagged_by_users)
    end
    
    it 'should be able to create relationship with @user included' do
      @user.related_tags.create(:tag_id => @tag.id)
      @tag.tagged_by_users.should include(@user)
    end
  end

  describe 'destruction' do
    before(:each) do
      @tag = Tag.create!(@attr)
    end

    it "should be successsful with basic attributes" do
      lambda do
        @tag.destroy
      end.should change(Tag,:count).by(-1)
    end

    it "should destroy tag association" do
      answer = Factory(:answer)
      @tag.reverse_answer_tags.create!(:answer_id => answer.id)
      lambda do
        @tag.destroy
      end.should change(AnswerTag,:count).by(-1)
    end

    it "should destroy StrainTag association" do
      strain = Factory(:strain)
      strain.strain_tags.create(:tag_id => @tag.id)
      lambda { @tag.destroy }.should change(StrainTag,:count).from(1).to(0)
    end
    
    it 'should destroy RelatedTag association' do
      user = Factory(:user)
      user.related_tags.create(:tag_id => @tag.id)
      lambda {@tag.destroy}.should change(RelatedTag, :count).from(1).to(0)
    end
  end
end
