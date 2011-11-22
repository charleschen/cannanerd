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
  
  describe 'answer_tag relationship' do
    before(:each) do
      @answer = Answer.create!(@attr)
      @tag = Factory(:tag)
    end
    
    it 'should respond to :answer_tags association' do
      @answer.should respond_to(:answer_tags)
    end
    
    it 'should respond to :tags' do
      @answer.should respond_to(:tags)
    end
    
    it 'should include tag in :tags with the association created' do
      @answer.answer_tags.create!(:tag_id => @tag.id)
      @answer.tags.should include(@tag)
    end
    
    it 'should respond to :tag! and create the association with it' do
      @answer.should respond_to(:tag!)
      @answer.tag!(@tag)
      @answer.tags.should include(@tag)
    end
    
    it 'should be able to untag' do
      @answer.should respond_to(:untag!)
      @answer.should respond_to(:has_tag?)
      
      @answer.tag!(@tag)
      #@answer.tags.should include(@tag)
      @answer.should have_tag(@tag)
      @answer.reload
      @answer.untag!(@tag)
      #@answer.tags.should_not include(@tag)
      @answer.should_not have_tag(@tag)
    end
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
    
    it "should destroy tag association" do
      tag = Factory(:tag)
      @answer.answer_tags.create!(:tag_id => tag.id)
      lambda do
        @answer.destroy
      end.should change(AnswerTag,:count).from(1).to(0)
    end
    
    it "should destroy questionship association" do
      questionnaire = Questionnaire.create
      question = Factory(:question, :questionnaire_id => questionnaire.id)
      question.questionships.create(:answer_id => @answer.id)
      
      lambda {@answer.destroy}.should change(Questionship,:count).from(1).to(0)
    end
    
  end
end
