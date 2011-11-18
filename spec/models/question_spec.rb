# == Schema Information
#
# Table name: questions
#
#  id               :integer         not null, primary key
#  content          :text
#  questionnaire_id :integer
#  multichoice      :boolean         default(FALSE)
#  created_at       :datetime
#  updated_at       :datetime
#  position         :integer
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
    #Question.create!(@attr.merge(:questionnaire_id => @questionnaire.id))
    Question.create!(:content => 'what?', :questionnaire_id => @questionnaire.id)
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
  
  describe 'reverse quiziation association' do
    before(:each) do
      @question = @questionnaire.questions.create(@attr)
      @quiz = Factory(:quiz)
    end
    
    it "should respond to :reverse_quiziation" do
      @question.should respond_to(:reverse_quiziations)
    end
    
    it "should respond to :quizzes" do
      @question.should respond_to(:quizzes)
    end
    
    it "should include quizzes after association has been created" do
      @quiz.quiziations.create(:question_id => @question.id)
      @question.quizzes.should include(@quiz)
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
    
    it 'should destory quiziation association' do
      quiz = Factory(:quiz)
      quiz.quiziations.create(:question_id => @question.id)
      lambda {@question.destroy}.should change(Quiziation,:count).from(1).to(0)
      @question.quizzes.should eq([])
    end
  end
end
