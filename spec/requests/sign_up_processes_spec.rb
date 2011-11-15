require 'spec_helper'

describe "SignUpProcesses" do
  before(:each) do
    @questionnaire = Questionnaire.create!
    create_questionaire_data
  end
  
  it 'should start with no quiz created' do
    visit root_path
    Quiz.count.should eq(0)
  end
end
