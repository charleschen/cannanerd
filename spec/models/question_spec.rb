# == Schema Information
#
# Table name: questions
#
#  id              :integer         not null, primary key
#  content         :text
#  questionnaire_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe Question do
  before(:each) do
    @attr = {:content => "Is this a question?"}
    @questionnaire = Questionnaire.create
  end
  
  it "should not create without the correct attributes" do
    Question.create.should_not be_valid
  end
  
  it "should not create without questionnaire reference" do
    Question.create(@attr).should_not be_valid
  end
  
  it "should create with the correct attributes and reference" do
    Question.create!(@attr.merge(:questionnaire_id => @questionnaire.id))
  end
  
  describe 'instance methods' do
    before(:each) do
      @questionnaire = Questionnaire.first
      @question = @questionnaire.questions.create(@attr)
    end
    
    it "should respond to questionnaire" do
      @question.should respond_to(:questionnaire)
    end
  end
  
  describe 'questionship association' do
    before(:each) do
      @question = @questionnaire.questions.create(@attr)
      @answer = Factory(:answer)
    end
    
    it "should respond to :answerships" do
      @question.should respond_to(:questionships)
    end
    
    it "should respond to :answers" do
      @question.should respond_to(:answers)
    end
    
    it "should create answership association" do
      @question.questionships.create(:answer_id => @answer.id)
      @question.answers.should include(@answer)
    end
  end
  
  describe 'destroy' do
    before(:each) do
      @question = @questionnaire.questions.create(@attr)
      @answer = Factory(:answer)
    end
    
    it "should destroy question" do
      lambda {@question.destroy}.should change(Question,:count).from(1).to(0)
    end
    
    it "should destroy answership association" do
      @question.questionships.create(:answer_id => @answer.id)
      lambda {@question.destroy}.should change(Questionship,:count).from(1).to(0)
      @answer.questions.should eq([])
    end
  end
end
