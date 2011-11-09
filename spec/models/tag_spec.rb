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

  describe 'destruction' do
    before(:each) do
      @tag = Tag.create!(@attr)
      @answer = Factory(:answer)
    end

    it "should be successsful with basic attributes" do
      lambda do
        @tag.destroy
      end.should change(Tag,:count).by(-1)
    end

    it "should destroy tag association" do
      @tag.reverse_answer_tags.create!(:answer_id => @answer.id)
      lambda do
        @tag.destroy
      end.should change(AnswerTag,:count).by(-1)
    end

  end
end
