class StrainsController < ApplicationController
  #filter_resource_access
  filter_access_to :all, :attribute_check => false
  
  def new
    @strain = Strain.new
  end
  
  def create
    @strain = Strain.new(params[:strain])
    
    if @strain.save
      flash[:success] = 'Created strain!'
      redirect_to strains_path
    else
      flash.now[:error] = 'Could not create strain'
      render 'new'
    end
  end
  
  def edit
    @strain = Strain.find(params[:id])
  end
  
  def update
    @strain = Strain.find(params[:id])
    if @strain.update_attributes(params[:strain])
      flash[:success] = 'Updated strain!'
      redirect_to strains_path
    else
      flash.now[:error] = 'Could not update strain'
      render 'edit'
    end
  end
  
  def destroy
    @strain = Strain.find(params[:id])
    @strain.destroy
    
    flash[:success] = "Strain deleted"
    redirect_to strains_path
  end
  
  def index
    @strains = Strain.all
  end
  
  def show
    @strain = Strain.find(params[:id])
  end
    
  def tags
    tag_type = params[:tag_type]
    unless tag_type.nil?
      @tags = Strain.tag_counts_on(tag_type.to_sym).where("tags.name LIKE ?", "%#{params[:q]}%")
      results = @tags.map{|t| {:id => t.name, :name => t.name}}
      results << {:id => params[:q], :name => "<strong>Add tag: #{params[:q]}</strong>"}
      respond_to do |format|
        format.json { render :json => results }
      end
    end
  end
  
  def all_tags
    @all_tags = Strain.all_tag_counts.where("tags.name LIKE ?", "%#{params[:q]}%")
    
    respond_to do |format|
      format.json { render :json => @all_tags.map{|t| {:id => t.name, :name => t.name}} }
    end
  end
end