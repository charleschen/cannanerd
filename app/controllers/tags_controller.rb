class TagsController < ApplicationController
  filter_resource_access
  
  def new
    
  end
  
  def create
    if @tag.save
      flash[:success] = 'Created tag!'
      redirect_to tags_path
    else
      flash[:error] = 'could not create'
      render :action => 'new'
    end
  end
  
  def index
    #@tags = Tag.all
    @tags = Tag.where("name like?", "%#{params[:q]}%")
  
    respond_to do |format|
      format.html
      format.json { render :json => @tags.map(&:attributes) }
    end
  end
  
  def edit
    
  end
  
  def update
    if @tag.update_attributes(params[:tag])
      flash[:sucess] = 'Updated tag'
      redirect_to tags_path
    else
      flash[:error] = 'Could not update tag'
      render :action => 'edit'
    end
  end
end