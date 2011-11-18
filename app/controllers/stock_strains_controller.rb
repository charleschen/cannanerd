class StockStrainsController < ApplicationController
  filter_resource_access
  
  def show
    
  end
  
  def create
    #raise params.inspect
    @club = Club.find(params[:stock_strain][:club_id])
    @club.add_to_inventory!(Strain.find(params[:stock_strain][:strain_id]))
    respond_to do |format|
      format.html { redirect_to @club }
    end
  end
  
  def destroy
    #raise params.inspect
    @club = Club.find(params[:stock_strain][:club_id])
    @club.remove_from_inventory!(Strain.find(params[:stock_strain][:strain_id]))
    respond_to do |format|
      format.html { redirect_to @club }
    end
  end
end