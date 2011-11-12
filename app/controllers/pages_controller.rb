class PagesController < ApplicationController
  def home
    if session[:quiz_attemp_id].nil?
      quiz = Quiz.create()
      quiz.question_ids = Questionaire.first.question_ids
      session[:quiz_attemp_id] = quiz.id
      session[:current_page] = quiz.current_page
    end
    
    @quiz = Quiz.find(session[:quiz_attemp_id])
    if params[:quiz]
      if @quiz.update_attributes(params[:quiz])
        flash.now[:success] = 'updated quiz'
      end
    end
    
    @quiz.current_page = session[:current_page]
    if params[:next_page]
      @quiziations = @quiz.quiziations.paginate(:page => @quiz.next_page, :per_page => 4)
      session[:current_page] = @quiz.current_page
    elsif params[:prev_page]
      @quiziations = @quiz.quiziations.paginate(:page => @quiz.prev_page, :per_page => 4)
      session[:current_page] = @quiz.current_page
    else
      @quiziations = @quiz.quiziations.paginate(:page => @quiz.current_page, :per_page => 4)
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

  def contact
    session[:quiz_attemp_id] = nil
  end

  def about
  end
  
  def submit_questionaire
    @questionaire = Questionaire.first
    session[:answers] = params[:answer]
    render :action => 'home'
  end

end
