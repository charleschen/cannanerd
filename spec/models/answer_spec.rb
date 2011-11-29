# == Schema Information
#
# Table name: answers
#
#  id          :integer         not null, primary key
#  content     :text
#  old_content :text
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Answer do
  before(:each) do
    @attr = { :content => 'this is an answer'}
  end
  
  it "should not create without the correct attribute" do
    Answer.create.should_not be_valid
  end
  
  it "should create with the correct attribute" do
    Answer.create!(@attr)
  end
  
  describe 'questionship relationship' do
    before(:each) do
      @answer = Answer.create(@attr)
      @questionnaire = Questionnaire.create
      @question = Factory(:question, :questionnaire_id => @questionnaire.id)
    end
    
    it "should respond to :reverse_questionships" do
      @answer.should respond_to(:reverse_questionships)
    end
    
    it "should respond to :questions" do
      @answer.should respond_to(:questions)
    end
    
    it "should create questionship relationship" do
      @question.questionships.create(:answer_id => @answer.id)
      @answer.questions.should include(@question)
    end
  end
  
  describe 'destruction' do
    before(:each) do
      @answer = Answer.create!(@attr)
    end
    
    it "should be successsful with basic attributes" do
      lambda do
        @answer.destroy
      end.should change(Answer,:count).from(1).to(0)
    end
    
    it "should destroy questionship association" do
      questionnaire = Questionnaire.create
      question = Factory(:question, :questionnaire_id => questionnaire.id)
      question.questionships.create(:answer_id => @answer.id)
      
      lambda {@answer.destroy}.should change(Questionship,:count).from(1).to(0)
    end
    
  end
end
