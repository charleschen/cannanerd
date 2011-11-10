# == Schema Information
#
# Table name: questions
#
#  id              :integer         not null, primary key
#  content         :text
#  questionaire_id :integer
#  created_at      :datetime
#  updated_at      :datetime
#

require 'spec_helper'

describe Question do
  before(:each) do
    @attr = {:content => "Is this a question?"}
    @questionaire = Questionaire.create
  end
  
  it "should not create without the correct attributes" do
    Question.create.should_not be_valid
  end
  
  it "should not create without questionaire reference" do
    Question.create(@attr).should_not be_valid
  end
  
  it "should create with the correct attributes and reference" do
    Question.create!(@attr.merge(:questionaire_id => @questionaire.id))
  end
  
  describe 'instance methods' do
    before(:each) do
      @questionaire = Questionaire.first
      @question = @questionaire.questions.create(@attr)
    end
    
    it "should respond to questionaire" do
      @question.should respond_to(:questionaire)
    end
  end
end
