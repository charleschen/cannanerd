class QuizzesController < ApplicationController
  def edit
    
  end
  
  def index
    
  end
  
  def update
    if params[:foward_button]
      @quiz = Quiz.find(session[:quiz_attemp_id])
      @quiziations = @quiz.quiziations.paginate(:page => params[:page].to_i+1, :per_page => 4)
      render 'pages/home'
    else
      
      @quiz = Quiz.find(params[:id])
    
      if @quiz.update_attributes(params[:quiz])
        flash[:success] = 'updated quiz'
        redirect_to new_user_path
      else
        flash[:error] = 'could not update quiz'
        redirect_to root_path
      end
    end
    
  end
  
end