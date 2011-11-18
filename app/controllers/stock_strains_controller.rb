class StockStrainsController < ApplicationController
  filter_resource_access
  
  def show
    @stock_strain = StockStrain.find(params[:id])
  end
  
  def create
    @club = Club.find(params[:stock_strain][:club_id])
    @strain = Strain.find(params[:stock_strain][:strain_id])
    @club.add_to_inventory!(@strain)
    @stock_strains = @club.stock_strains
    respond_to do |format|
      format.html { redirect_to @club }
      format.js
    end
  end
  
  def edit
    
  end
  
  def update
    if @stock_strain.update_attributes(params[:stock_strain])
      flash[:success] = "Strain updated"
      redirect_to stock_strain_path(@stock_strain)
    else
      flash.now[:error] = 'Couldn not update strain'
      render 'edit'
    end
  end
  
  def destroy
    @club = Club.find(params[:stock_strain][:club_id])
    @strain = Strain.find(params[:stock_strain][:strain_id])
    @club.remove_from_inventory!(@strain)
    @stock_strains = @club.stock_strains
    
    puts @stock_strains.count
    respond_to do |format|
      format.html { redirect_to @club }
      format.js
    end
  end
end