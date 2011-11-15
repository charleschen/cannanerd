# == Schema Information
#
# Table name: questionnaires
#
#  id         :integer         not null, primary key
#  per_page   :integer         default(4)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Questionnaire do
  before(:each) do
    @attr = {}
  end
  
  it "should not be able to create new instances" do
    Questionnaire.create!
    lambda { Questionnaire.create }.should_not change(Questionnaire, :count)
  end
  
  it "making a new instance and saving should not add a new row to database" do
    Questionnaire.create!
    lambda do
      questionnaire = Questionnaire.new
      questionnaire.save
    end.should_not change(Questionnaire, :count).by(1)
  end
  
  it "should respond to many questions" do
    questionnaire = Questionnaire.create!
    questionnaire.should respond_to(:questions)
  end
end
