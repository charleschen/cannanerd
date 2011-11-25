def generate_answer_strain(tag_list)
  tag_ids = []
  answer_ids = []
  tag_list.count.times do |count|
    # tag = Factory(:tag, :name => tag_list[count][0], :category => tag_list[count][1])
    # tag_ids << tag.id
    answer = Factory(:answer)
    answer_ids << answer.id
  end
  
  
  tag_list.count.times do |count|
    strain = Factory(:strain, :name => "a#{count}")
    strain.id_str = "#{count+1}"
    strain.save
    #strain.tag_ids = tag_ids[0..count]
  end
  
  answer_ids
end

def generate_quiz()
  
end

def generate_quiz(answer_list,num_of_answers)
  quiz = Quiz.create()
  
  r = Random.new
  tag_iter = 0
  
  num_of_answers.times do |count|
    question = Question.create(:content => 'meh?', :questionnaire_id => Questionnaire.first, :position => count+1)
    quiziation = quiz.quiziations.create(:question_id => question.id)
    #quiziation.answers_hash =  {answer_list[count]}  #"{:answer_#{AnswerTag.find_by_tag_id(tag.id).answer.id} => 1}"
  end
  
  quiz
end

def generate_answer_tag_all_strain(tag_list)
  tag_ids = []
  tag_list.count.times do |count|
    tag = Factory(:tag, :name => tag_list[count][0], :category => tag_list[count][1])
    tag_ids << tag.id
    answer = Factory(:answer)
    answer.answer_tags.create(:tag_id => tag.id)
  end
  
  tag_list.count.times do |count|
    strain = Factory(:strain, :name => "a#{count}")
    strain.id_str = "#{count+1}"
    strain.save
    strain.tag_ids = tag_ids[0...tag_ids.count]
  end
end

def create_questionnaire_data_with_tags
  questionnaire = Questionnaire.first
  multichoice = true
  
  tag_list = []
  
  3.times do
    question = Factory(:question, :questionnaire_id => questionnaire.id, :multichoice => true)
    3.times do
      answer = Factory(:answer)
      fake_tag = Faker::Name.first_name
      while(tag_list.include?(fake_tag))
        fake_tag = Faker::Name.first_name
      end
      tag_list << fake_tag
      answer.tag_list.add(fake_tag)
      question.questionships.create(:answer_id => answer.id)
    end
  end
  
  tag_list
end

def create_questionaire_data
  questionnaire = Questionnaire.first
  multichoice = true
  
  tag_list = []
  
  3.times do
    question = Factory(:question, :questionnaire_id => questionnaire.id, :multichoice => multichoice)
    multichoice = !multichoice
    3.times do
      answer = Factory(:answer)
      fake_tag = Faker::Name.first_name
      while(tag_list.include?(fake_tag))
        fake_tag = Faker::Name.first_name
      end
      tag_list << fake_tag
      answer.tag_list.add(fake_tag)
      question.questionships.create(:answer_id => answer.id)
    end
  end
  
  tag_list
end
