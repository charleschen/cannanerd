class QuestionnairesController < ApplicationController
  filter_resource_access
  
  def new
    
  end
  
  def edit
    @answer = Answer.new
  end
  
  def update
    if @questionnaire.update_attributes(params[:questionnaire])
      flash[:notice] = "Questionnaire updated"
      redirect_to questionnaires_path
    else
      render :action => 'edit'
    end
  end
  
  def index
    @questionnaire = Questionnaire.first
  end
end