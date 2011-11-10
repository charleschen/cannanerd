# == Schema Information
#
# Table name: questionaires
#
#  id         :integer         not null, primary key
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Questionaire do
  before(:each) do
    @attr = {}
  end
  
  it "should not be able to create new instances" do
    Questionaire.create!
    lambda { Questionaire.create }.should_not change(Questionaire, :count)
  end
  
  it "making a new instance and saving should not add a new row to database" do
    Questionaire.create!
    lambda do
      questionaire = Questionaire.new
      questionaire.save
    end.should_not change(Questionaire, :count).by(1)
  end
  
  it "should respond to many questions" do
    questionaire = Questionaire.create!
    questionaire.should respond_to(:questions)
  end
end
