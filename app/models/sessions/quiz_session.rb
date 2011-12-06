class QuizSession
  def initialize(session)
    @session = session
  end
  
  def new_quiz?
    if @session[:quiz_attempt_id].nil?
      true
    else
      quiz = Quiz.find_by_id(@session[:quiz_attempt_id])
      if quiz.nil?
        return true
      else
        quiz.updated_at <= 15.minutes.ago || quiz.user_id.nil? == false
      end
    end
  end
  
  def submit_quiz?
    if @session[:quiz_attempt_id].nil? == false
      quiz = Quiz.find_by_id(@session[:quiz_attempt_id])
      quiz.nil? == false && quiz.user_id.nil?
    else
      false
    end
  end
  
  def init_quiz
    quiz = Quiz.create(:question_ids => Questionnaire.first.question_ids)
    @session[:quiz_attempt_id] = quiz.id
    @session[:current_page] = quiz.current_page
  end
  
  def get_quiz
    Quiz.find_by_id(@session[:quiz_attempt_id])
  end
  
  def current_page
    @session[:current_page].to_i
  end
  
  def update_quiz(quiz_params)
    Quiz.find(@session[:quiz_attempt_id]).update_attributes(quiz_params)
  end
  
  def reset_quiz
    @session[:quiz_attempt_id] = nil
  end
end