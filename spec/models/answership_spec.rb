# == Schema Information
#
# Table name: answerships
#
#  id         :integer         not null, primary key
#  answer_id  :integer
#  user_id    :integer
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Answership do
  before(:each) do
    @user = Factory(:user)
    @answer = Factory(:answer)
  end
  
  it "should no create relationship without associations" do
    Answership.create.should_not be_valid
  end
  
  it "should not create a relationship without answer reference" do
    relationship = @user.answerships.create()
    relationship.should_not be_valid
  end
  
  it "should create a relationship" do
    @user.answerships.create!(:answer_id => @answer.id)
  end
end
