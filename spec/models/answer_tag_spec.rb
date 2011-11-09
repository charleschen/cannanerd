# == Schema Information
#
# Table name: answer_tags
#
#  id         :integer         not null, primary key
#  answer_id  :integer
#  tag_id     :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe AnswerTag do
  before(:each) do
    @answer = Factory(:answer)
    @tag = Factory(:tag)
  end
  
  it "should not be able to create without the right associations" do
    AnswerTag.create().should_not be_valid
  end
  
  it "should not create with just one association" do
    AnswerTag.create(:answer_id => @answer.id).should_not be_valid
    AnswerTag.create(:tag_id => @tag.id).should_not be_valid
  end
  
  it "should create with the correct associations" do
    #AnswerTag.create!(:answer_id => @answer.id, :tag_id => @tag.id)
    @answer.answer_tags.create!(:tag_id => @tag.id)
  end
  
  describe 'tagging methods' do
    before(:each) do
      
    end
  end
end
