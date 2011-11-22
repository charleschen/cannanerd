def generate_answer_tag_strain(tag_list)
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
    strain.tag_ids = tag_ids[0..count]
  end
end

def generate_quiz(tag_list,num_of_answers)
  quiz = Quiz.create()
  
  r = Random.new
  tag_iter = 0
  
  num_of_answers.times do |count|
    question = Question.create(:content => 'meh?', :questionnaire_id => Questionnaire.first, :position => count+1)
    quiziation = quiz.quiziations.create(:question_id => question.id)
    #answers_count = r.rand(0...tag_list.count)
    # answers_count.times do |tag_index|
    #   tag = Tag.find_by_name(tag_list[tag_index][0])
    #   hash.merge = {"answer_#{AnswerTag.find_by_tag_id(tag.id).answer.id}".to_sym => 1}
    # end
    tag = Tag.find_by_name(tag_list[count][0])
    quiziation.answers_hash = "{:answer_#{AnswerTag.find_by_tag_id(tag.id).answer.id} => 1}"
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
