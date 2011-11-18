class QuestionnairesController < ApplicationController
  filter_resource_access :new => :sort , :attribute_check => false
  
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
    @questions = @questionnaire.questions.order("position")
  end
  
  def sort
    params[:question].each_with_index do |id,index|
      Question.update_all({position: index+1}, {id: id})
    end
    render nothing: true
  end
end