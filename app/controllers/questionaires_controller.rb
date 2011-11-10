class QuestionairesController < ApplicationController
  filter_resource_access
  
  def new
    
  end
  
  def edit
  end
  
  def update
    if @questionaire.update_attributes(params[:questionaire])
      flash[:notice] = "Questionaire updated"
      redirect_to questionaires_path
    else
      render :action => 'edit'
    end
  end
  
  def index
    @questionaire = Questionaire.first
  end
end