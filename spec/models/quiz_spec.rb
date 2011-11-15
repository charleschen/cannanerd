# == Schema Information
#
# Table name: quizzes
#
#  id         :integer         not null, primary key
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Quiz do
  before(:each) do
    @attr = {}
  end
  
  it "should create quiz" do
    Quiz.create!()
  end
  
  describe 'quiziation association' do
    before(:each) do
      @quiz = Quiz.create(@attr)
      
      @questionnaire = Questionnaire.create
      @question = Factory(:question,:questionnaire_id => @questionnaire.id)
    end
    
    it 'should respond to :quiziations' do
      @quiz.should respond_to(:quiziations)
    end
    
    it 'should respond to :questions' do
      @quiz.should respond_to(:questions)
    end
    
    it 'should create a association with question' do
      @quiz.quiziations.create(:question_id => @question.id)
      @quiz.questions.should include(@question)
    end
  end
  
  describe 'quiz pagination' do
    before(:each) do
      @quiz = Quiz.create(@attr)
      @questionnaire = Questionnaire.create
      @questionnaire.update_attribute(:per_page,2)
    end
    
    it "should respond to :current_page" do
      @quiz.should respond_to(:current_page)
      @quiz.current_page.should eq(1)
    end
    
    it "should respond to first_page?" do
      @quiz.current_page
      @quiz.should respond_to(:first_page?)
      @quiz.should be_first_page
    end
    
    it "should respond to last_page?" do
      @quiz.current_page
      @quiz.should respond_to(:last_page?)
      @quiz.should be_last_page
    end
    
    it "should respond to next_page" do
      @quiz.current_page
      @quiz.should respond_to(:next_page)
      @quiz.next_page.should eq(1)
    end
    
    it "should respond to prev_page" do
      @quiz.current_page
      @quiz.should respond_to(:prev_page)
      @quiz.prev_page.should eq(1)
    end
    
    it "should have 3 pages with 5 questions" do
      5.times do
        question = Factory(:question,:questionnaire_id => @questionnaire.id)
        @quiz.quiziations.create(:question_id => question.id)
      end
      @quiz.current_page.should eq(1)
      @quiz.should_not be_last_page
      @quiz.should be_first_page
      
      @quiz.next_page.should eq(2)
      @quiz.next_page.should eq(3)
      @quiz.next_page.should eq(3)
      @quiz.should be_last_page
      @quiz.should_not be_first_page
      
      @quiz.prev_page.should eq(2)
      @quiz.prev_page.should eq(1)
      @quiz.prev_page.should eq(1)
      @quiz.should be_first_page
      
    end
  end
  
  describe 'on destory' do
    before(:each) do
      @quiz = Quiz.create(@attr)
    end
    
    it 'should destroy itself' do
      lambda { @quiz.destroy }.should change(Quiz,:count).from(1).to(0)
    end
    
    it 'should destroy quiziation reference' do
      questionnaire = Questionnaire.create
      question = Factory(:question, :questionnaire_id => questionnaire.id)
      
      @quiz.quiziations.create(:question_id => question.id)
      lambda { @quiz.destroy }.should change(Quiziation,:count).from(1).to(0)
    end
  end
  
end
