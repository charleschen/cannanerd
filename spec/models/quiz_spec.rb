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
support_require 'data_generator'

describe Quiz do
  let(:tag_list){
    [['indica','strain'],
                ['sativa','strain'],
                ['ADD','medical'],
                ['ADHD','medical'],
                ['cancer','medical'],
                ['PTSD','medical'],
                ['Aroused','effect'],
                ['giggly','effect'],
                ['sweet','flavor'],
                ['spicy','flavor'],
                ['hungry','effect']]}
  
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
  
  describe 'quiz answers' do
    before(:each) do
      @questionnaire = Questionnaire.create
    end
    
    it 'generate_answer_tag_strain should have the right values' do
      generate_answer_tag_strain(tag_list)
      
      Tag.count.should == tag_list.count
      Answer.count.should == tag_list.count
      Strain.count.should == tag_list.count
      
      Strain.all.each do |strain|
        #strain.tags.count.should == strain.id_str.to_i
        #puts strain.tags.count.should == strain.id_str.to_i
        strain.tags.count.should == strain.id_str.to_i
      end
    end
    
    it 'should generate a quiz with generate_quiz method' do
      
      generate_answer_tag_strain(tag_list)
      quiz = generate_quiz(tag_list,11)
      quiz.quiziations.count.should == 11
      quiz.quiziations.each do |quiziation|
        eval(quiziation.answers_hash).count.should eq(1)
      end
    end
    
    it 'should respond to :answer_ids' do
      quiz = Quiz.create(@attr)
      quiz.should respond_to(:answer_ids)
    end
    
    it 'should give the right answer ids' do
      generate_answer_tag_strain(tag_list)
      quiz = generate_quiz(tag_list,11)
      answer_ids = quiz.answer_ids
      answer_ids.count.should eq(11)
      tag_list.count.times do |count|
        answer_ids.should include(AnswerTag.find_by_tag_id(Tag.find_by_name(tag_list[count][0])).answer.id)
      end
      
      quiz = generate_quiz(tag_list, 5)
      answer_ids = quiz.answer_ids
      answer_ids.count.should eq(5)
      tag_list.count.times do |count|
        if count < 5
          answer_ids.should include(AnswerTag.find_by_tag_id(Tag.find_by_name(tag_list[count][0])).answer.id)
        else
          answer_ids.should_not include(AnswerTag.find_by_tag_id(Tag.find_by_name(tag_list[count][0])).answer.id)
        end
      end
      
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
