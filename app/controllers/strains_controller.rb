class StrainsController < ApplicationController
  filter_resource_access
  
  def new
    
  end
  
  def create
    if @strain.save
      flash[:success] = 'Created strain!'
      redirect_to strains_path
    else
      flash.now[:error] = 'Could not create strain'
      render 'new'
    end
  end
  
  def edit
    
  end
  
  def update
    if @strain.update_attributes(params[:strain])
      flash[:success] = 'Updated strain!'
      redirect_to strains_path
    else
      flash.now[:error] = 'Could not update strain'
      render 'edit'
    end
  end
  
  def destroy
    
  end
  
  def index
    @strains = Strain.all
  end
  
  def show
    
  end
end