class QuestionairesController < ApplicationController
  filter_resource_access
  
  def new
    
  end
  
  def edit
    @answer = Answer.new
  end
  
  def update
    render :action => 'edit'
    # if @questionaire.update_attributes(params[:questionaire])
    #   flash[:notice] = "Questionaire updated"
    #   redirect_to questionaires_path
    # else
    #   render :action => 'edit'
    # end
    # 
    # @temp_answer = "werd"
  end
  
  def index
    @questionaire = Questionaire.first
  end
end