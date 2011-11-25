require 'spec_helper'
support_require 'data_generator'

describe UpdateTagList do
  let(:user) { Factory(:user) }
  let(:question) { Factory(:question, :questionnaire_id => Questionnaire.first)}
  
  before(:each) do
    @questionnaire = Questionnaire.create()
  end
  
  it 'should respond to :perform' do
    UpdateTagList.should respond_to(:perform)
  end
    
  it 'should run perform' do
    quiz = Factory(:quiz)
    curr_user = user
    quiz.user_id = curr_user.id
    quiz.save
    
    UpdateTagList.perform(user.id)
  end
  
  it 'should generate the right user tags' do
    answer_ids = []
    tag_list = []
    tag = Faker::Name::first_name
    5.times do
      tag = Faker::Name::first_name while(tag_list.include?(tag))
      answer = Factory(:answer)
      answer.tag_list.add(tag)
      answer.save
      
      answer_ids << answer.id
      tag_list << tag
    end
    
    User.any_instance.stubs(:latest_answers).returns(answer_ids)
    curr_user = user
    UpdateTagList.perform(curr_user.id)
    
    curr_user.reload
    tag_list.each do |tag|
      curr_user.tag_list.should include(tag)
    end
    
  end
end