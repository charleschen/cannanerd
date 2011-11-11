require 'spec_helper'

describe Questionship do
  before(:each) do
    @questionaire = Questionaire.first || Questionaire.create
    @question = Factory(:question, :questionaire_id => @questionaire.id)
    @answer = Factory(:answer)
  end
  
  it "should not create association without correct references" do
    Questionship.create.should_not be_valid
  end
  
  it "should not create association without answer reference" do
    @question.questionships.create().should_not be_valid
  end
  
  it "should create association" do
    @question.questionships.create!(:answer_id => @answer.id)
  end
end
