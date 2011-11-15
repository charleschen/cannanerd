# == Schema Information
#
# Table name: quiziations
#
#  id           :integer         not null, primary key
#  quiz_id      :integer
#  question_id  :integer
#  answers_hash :string(255)     default("{}")
#  created_at   :datetime
#  updated_at   :datetime
#

require 'spec_helper'

describe Quiziation do
  before(:each) do
    @quiz = Quiz.create
    @questionnaire = Questionnaire.create
    @question = Factory(:question,:questionnaire_id => @questionnaire.id)
  end
  
  it "should not be valid without any reference" do
    Quiziation.create.should_not be_valid
  end
  
  it "should not be valid without question_id reference" do
    @quiz.quiziations.create.should_not be_valid
  end
  
  it "should be valid with the right reference" do
    quiziation = @quiz.quiziations.create!(:question_id => @question.id)
    quiziation.answers_hash.should eq("{}")
  end
  
  describe 'instance methods' do
    before(:each) do
      @quiziation = @quiz.quiziations.create!(:question_id => @question.id)
      @answer1 = 'answer_20;1'
      @answer2 = 'answer_21;1'
      @answer3 = 'answer_20;0'
    end
    
    it "should respond to :checked_answers" do
      @quiziation.should respond_to(:checked_answers)
      @quiziation.checked_answers.should eq([])
    end
    
    it "should be able to set :checked_answers" do
      @quiziation.checked_answers = @answer1
      @quiziation.reload
      @quiziation.checked_answers.should eq([@answer1])
    end
    
    it 'should respond correctly with the right answer for :checked_answers' do
      @quiziation.checked_answers = @answer1
      @quiziation.checked_answers = @answer2
      @quiziation.reload
      @quiziation.checked_answers.should include(@answer1,@answer2)
      @quiziation.checked_answers = @answer3
      @quiziation.checked_answers.should_not include(@answer1)
    end
    
    it "should respond to :radio_answer" do
      @quiziation.should respond_to(:radio_answer)
      @quiziation.radio_answer.should be_nil
    end
    
    it "should be able to set :radio_answer" do
      @quiziation.radio_answer = @answer1
      @quiziation.radio_answer.should eq(@answer1)
    end
    
    it 'should only set 1 answer each time for radio_answer' do
      @quiziation.radio_answer = @answer1
      @quiziation.radio_answer = @answer2
      @quiziation.radio_answer.should eq(@answer2)
    end
  end
end
