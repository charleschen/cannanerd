class PagesController < ApplicationController
  def home
    @questionaire = Questionaire.first    
    @questions = @questionaire.questions.paginate(:page => params[:page], :per_page => 4)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def contact
  end

  def about
  end
  
  def submit_questionaire
    @questionaire = Questionaire.first
    session[:answers] = params[:answer]
    render :action => 'home'
  end

end
