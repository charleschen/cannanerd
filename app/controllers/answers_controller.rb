class AnswersController < ApplicationController
  filter_access_to :all, :attribute_check => false
  
  def edit
    @answer = Answer.find(params[:id])
  end
  
  def update
    @answer = Answer.find(params[:id])
    if @answer.update_attributes(params[:answer])
      flash[:success] = "Updated tag answer"
      redirect_to answers_path
    else
      flash[:error] = 'Could not add tag'
      render :action => 'edit'
    end
  end
  
  def index
    @answers = Answer.all
    
    current_page = params[:page]
    
    @answers_section1 = Answer.paginate(:page => params[:page], :per_page => 6)
  end
  
end