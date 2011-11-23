require 'spec_helper'
support_require 'data_generator'

describe UpdateUserTags do
  let(:user) { Factory(:user) }
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
    questionnaire = Questionnaire.create()
  end
    
  it 'should respond to perform' do
    UpdateUserTags.should respond_to(:perform)
  end
  
  it 'should run perform' do
    generate_answer_tag_strain(tag_list)
    quiz = generate_quiz(tag_list,11)
    
    user = Factory(:user)
    quiz.user_id = user.id
    quiz.save
    
    UpdateUserTags.perform(user.id)
    
  end
  
  it 'should create user tag relationships' do
    generate_answer_tag_strain(tag_list)
    quiz = generate_quiz(tag_list,11)
    answer_ids = quiz.answer_ids
    user = Factory(:user)
    quiz.user_id = user.id
    quiz.save
    
    lambda { UpdateUserTags.perform(user.id) }.should change(RelatedTag,:count).from(0).to(11)
    
    tag_list.each do |tag|
      user.tags.should include(Tag.find_by_name(tag[0]))
    end

  end
  
  it 'should only generate the max amount of tag relationships (no overlapping)' do
    generate_answer_tag_all_strain(tag_list)
    quiz = generate_quiz(tag_list,11)
    answer_ids = quiz.answer_ids
    user = Factory(:user)
    quiz.user_id = user.id
    quiz.save
    
    lambda { UpdateUserTags.perform(user.id) }.should change(RelatedTag,:count).from(0).to(11)
    
    tag_list.each do |tag|
      user.tags.should include(Tag.find_by_name(tag[0]))
    end
    
    user_2 = Factory(:user, :email => 'harro@gmail.com')
    quiz = generate_quiz(tag_list,11)
    quiz.user_id = user_2.id
    quiz.save
    
    lambda { UpdateUserTags.perform(user_2.id)}.should change(RelatedTag,:count).from(11).to(22)
    
  end
end