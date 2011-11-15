class PagesController < ApplicationController
  before_filter :authorize_test, :only => [:take_quiz]
  
  def home
    unless any_user?
      unless quiz_session.new_quiz?
        quiz_session.update_quiz(params[:quiz]) if params[:quiz]
      
        @questionnaire = Questionnaire.first
        @quiz = quiz_session.get_quiz
      
      
        @quiz.current_page = quiz_session.current_page
      
        if params[:next_page]
          @quiziations = @quiz.quiziations.paginate(:page => @quiz.next_page, :per_page => @questionnaire.per_page)
          session[:current_page] = @quiz.current_page
        elsif params[:prev_page]
          @quiziations = @quiz.quiziations.paginate(:page => @quiz.prev_page, :per_page => @questionnaire.per_page)
          session[:current_page] = @quiz.current_page
        else
          @quiziations = @quiz.quiziations.paginate(:page => @quiz.current_page, :per_page => @questionnaire.per_page)
        end
      
        respond_to do |format|
          if params[:submit]
            format.html { redirect_to new_user_path }
          else
            format.html
          end
          format.js
        end
      end
    end
  end
  
  def take_quiz
    quiz_session.init_quiz
    
    @quiz = quiz_session.get_quiz
    @quiziations = @quiz.quiziations.paginate(:page => @quiz.current_page, :per_page => Questionnaire.first.per_page)
    
    respond_to do |format|
      format.html { redirect_to root_path }
      format.js
    end
    
    # if session[:quiz_attemp_id].nil?
    #   quiz = Quiz.create()
    #   quiz.question_ids = Questionnaire.first.question_ids
    #   session[:quiz_attemp_id] = quiz.id
    #   session[:current_page] = quiz.current_page
    # end
    # 
    # @quiz = Quiz.find(session[:quiz_attemp_id])
    # @questionnaire = Questionnaire.first
    # 
    # if params[:quiz]
    #   unless @quiz.update_attributes(params[:quiz])
    #     flash[:now] = "Quiz not updating... please email administrator!"
    #   end
    # end
    # 
    # @quiz.current_page = session[:current_page]
    # if params[:next_page]
    #   @quiziations = @quiz.quiziations.paginate(:page => @quiz.next_page, :per_page => @questionnaire.per_page)
    #   session[:current_page] = @quiz.current_page
    # elsif params[:prev_page]
    #   @quiziations = @quiz.quiziations.paginate(:page => @quiz.prev_page, :per_page => @questionnaire.per_page)
    #   session[:current_page] = @quiz.current_page
    # else
    #   @quiziations = @quiz.quiziations.paginate(:page => @quiz.current_page, :per_page => @questionnaire.per_page)
    # end
    # 
    # respond_to do |format|
    #   if params[:submit]
    #     format.html { redirect_to new_user_path }
    #   else
    #     format.html
    #   end
    #   format.js
    # end
  end

  def contact
    session[:quiz_attempt_id] = nil
  end

  def about
  end
  
  private 
    def authorize_test
      unless quiz_session.new_quiz?
        flash[:error] = "Cannot take a new test yet"
        redirect_to root_url
      end
    end

end
