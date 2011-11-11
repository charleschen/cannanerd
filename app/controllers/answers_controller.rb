class AnswersController < ApplicationController
  filter_resource_access
  
  def edit
    
  end
  
  def update
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
    current_page ||= 1
    
    @answers_section1 = Answer.paginate(:page => current_page, :per_page => 6)
    @answers_section2 = Answer.paginate(:page => (current_page.to_i+1), :per_page => 6)
  end
end