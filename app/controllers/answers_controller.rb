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
  end
end